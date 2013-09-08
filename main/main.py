# -*- coding: utf-8 -*-

from google.appengine.api import mail
from flaskext import wtf
import datetime
import time
import flask
import config
import model
import util


app = flask.Flask(__name__)
app.config.from_object(config)
app.jinja_env.line_statement_prefix = '#'
app.jinja_env.line_comment_prefix = '##'
app.jinja_env.globals.update(slugify=util.slugify)

import auth
import admin


################################################################################
# Main page
################################################################################
@app.route('/<int:timestamp>')
@app.route('/<int:timestamp>/<path:title>')
@app.route('/<int:year>-<int:month>-<int:day>')
@app.route('/<int:year>-<int:month>-<int:day>/<path:title>')
@app.route('/<int:year>-<int:month>-<int:day>-<int:hour>')
@app.route('/<int:year>-<int:month>-<int:day>-<int:hour>/<path:title>')
@app.route('/<int:year>-<int:month>-<int:day>-<int:hour>:<int:minute>')
@app.route('/<int:year>-<int:month>-<int:day>-<int:hour>:<int:minute>/<path:title>')
@app.route('/<int:hour>:<int:minute>')
@app.route('/<int:hour>:<int:minute>/<path:title>')
@app.route('/')
@app.route('/<path:title>')
def countdown(timestamp=None, year=None, month=1, day=1, hour=None, minute=0, title=None):
  if year is not None and hour is not None:
    try:
      date = datetime.datetime(year, month, day, hour, minute)
      timestamp = date.strftime('%s')
    except:
      pass
  elif year is not None:
    try:
      date = datetime.datetime(year, month, day)
      timestamp = date.strftime('%s')
    except:
      pass
  elif hour is not None:
    try:
      now = datetime.datetime.utcnow()
      date = datetime.datetime(now.year, now.month, now.day, hour, minute)
      timestamp = date.strftime('%s')
    except:
      pass

  return flask.render_template(
      'countdown.html',
      html_class='countdown',
      timestamp=timestamp,
      title=title,
      now=datetime.datetime.utcnow(),
    )


################################################################################
# Sitemap stuff
################################################################################
@app.route('/sitemap.xml')
def sitemap():
  response = flask.make_response(flask.render_template(
      'sitemap.xml',
      host_url=flask.request.host_url[:-1],
      lastmod=config.CURRENT_VERSION_DATE.strftime('%Y-%m-%d'),
    ))
  response.headers['Content-Type'] = 'application/xml'
  return response


################################################################################
# Feedback
################################################################################
class FeedbackForm(wtf.Form):
  subject = wtf.TextField('Subject', [wtf.validators.required()])
  message = wtf.TextAreaField('Message', [wtf.validators.required()])
  email = wtf.TextField('Email (optional)', [
      wtf.validators.optional(),
      wtf.validators.email('That does not look like an email'),
    ])


@app.route('/feedback/', methods=['GET', 'POST'])
def feedback():
  if not config.CONFIG_DB.feedback_email:
    return flask.abort(418)

  form = FeedbackForm()
  if form.validate_on_submit():
    mail.send_mail(
        sender=config.CONFIG_DB.feedback_email,
        to=config.CONFIG_DB.feedback_email,
        subject='[%s] %s' % (
            config.CONFIG_DB.brand_name,
            form.subject.data.strip(),
          ),
        reply_to=form.email.data.strip() or config.CONFIG_DB.feedback_email,
        body='%s\n\n%s' % (form.message.data.strip(), form.email.data.strip())
      )
    flask.flash('Thank you for your feedback!', category='success')
    return flask.redirect(flask.url_for('countdown'))
  if not form.errors and auth.current_user_id() > 0:
    form.email.data = auth.current_user_db().email

  return flask.render_template(
      'feedback.html',
      title='Feedback',
      html_class='feedback',
      form=form,
    )


################################################################################
# Error Handling
################################################################################
@app.errorhandler(400)  # Bad Request
@app.errorhandler(401)  # Unauthorized
@app.errorhandler(403)  # Forbidden
@app.errorhandler(404)  # Not Found
@app.errorhandler(405)  # Method Not Allowed
@app.errorhandler(410)  # Gone
@app.errorhandler(418)  # I'm a Teapot
@app.errorhandler(500)  # Internal Server Error
def error_handler(e):
  try:
    e.code
  except:
    class e(object):
      code = 500
      name = 'Internal Server Error'

  if flask.request.path.startswith('/_s/'):
    return util.jsonpify({
        'status': 'error',
        'error_code': e.code,
        'error_name': e.name.lower().replace(' ', '_'),
        'error_message': e.name,
      }), e.code

  return flask.render_template(
      'error.html',
      title='Error %d (%s)!!1' % (e.code, e.name),
      html_class='error-page',
      error=e,
    ), e.code
