# -*- coding: utf-8 -*-

import flask
from flaskext import wtf

import auth
import util
import model
import config

from main import app


class ConfigUpdateForm(wtf.Form):
  analytics_id = wtf.TextField('Analytics ID', filters=[util.strip_filter])
  brand_name = wtf.TextField('Brand Name', [wtf.validators.required()], filters=[util.strip_filter])
  feedback_email = wtf.TextField('Feedback Email', [wtf.validators.optional(), wtf.validators.email()], filters=[util.strip_filter])
  flask_secret_key = wtf.TextField('Flask Secret Key', [wtf.validators.required()], filters=[util.strip_filter])
  google_api_key = wtf.TextField('Google API Key')


@app.route('/admin/config/', methods=['GET', 'POST'])
@auth.admin_required
def admin_config_update():
  config_db = model.Config.get_master_db()
  form = ConfigUpdateForm(obj=config_db)
  if form.validate_on_submit():
    form.populate_obj(config_db)
    config_db.put()
    reload(config)
    app.config.update(CONFIG_DB=config_db)
    return flask.redirect(flask.url_for('welcome'))

  if flask.request.path.startswith('/_s/'):
    return util.jsonify_model_db(config_db)

  return flask.render_template(
      'admin/config_update.html',
      title='Admin Config',
      html_class='admin-config',
      form=form,
      config_db=config_db,
      has_json=True,
    )
