# -*- coding: utf-8 -*-

import flask
from flaskext import wtf

import auth
import util
import model
import config

from main import app


class ConfigUpdateForm(wtf.Form):
  analytics_id = wtf.TextField('Analytics ID')
  brand_name = wtf.TextField('Brand Name', [wtf.validators.required()])
  feedback_email = wtf.TextField('Feedback Email', [
      wtf.validators.optional(),
      wtf.validators.email('That does not look like an email')
    ])
  flask_secret_key = wtf.TextField('Flask Secret Key', [
      wtf.validators.required()
    ])


@app.route('/admin/config/', methods=['GET', 'POST'])
@auth.admin_required
def admin_config_update():
  form = ConfigUpdateForm()

  config_db = model.Config.get_master_db()
  if form.validate_on_submit():
    config_db.analytics_id = form.analytics_id.data.strip()
    config_db.brand_name = form.brand_name.data.strip()
    config_db.feedback_email = form.feedback_email.data.strip()
    config_db.flask_secret_key = form.flask_secret_key.data.strip()
    config_db.put()
    reload(config)
    app.config.update(CONFIG_DB=config_db)
    return flask.redirect(flask.url_for('countdown'))
  if not form.errors:
    form.analytics_id.data = config_db.analytics_id
    form.brand_name.data = config_db.brand_name
    form.feedback_email.data = config_db.feedback_email
    form.flask_secret_key.data = config_db.flask_secret_key

  if flask.request.path.startswith('/_s/'):
    return util.jsonify_model_db(config_db)

  return flask.render_template(
      'admin/config_update.html',
      title='Admin Config',
      html_class='admin-config',
      form=form,
      config_db=config_db,
    )
