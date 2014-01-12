# -*- coding: utf-8 -*-

import os

from google.appengine.ext import ndb

import modelx
import util


# The timestamp of the currently deployed version
TIMESTAMP = long(os.environ.get('CURRENT_VERSION_ID').split('.')[1]) >> 28


class Base(ndb.Model, modelx.BaseX):
  created = ndb.DateTimeProperty(auto_now_add=True)
  modified = ndb.DateTimeProperty(auto_now=True)
  version = ndb.IntegerProperty(default=TIMESTAMP)
  _PROPERTIES = {
      'key',
      'id',
      'version',
      'created',
      'modified',
    }


class Config(Base, modelx.ConfigX):
  analytics_id = ndb.StringProperty(default='')
  announcement_html = ndb.StringProperty(default='')
  announcement_type = ndb.StringProperty(default='info', choices=[
      'info', 'warning', 'success', 'danger',
    ])
  brand_name = ndb.StringProperty(default='Hurry App')
  facebook_app_id = ndb.StringProperty(default='')
  facebook_app_secret = ndb.StringProperty(default='')
  feedback_email = ndb.StringProperty(default='')
  flask_secret_key = ndb.StringProperty(default=util.uuid())
  google_api_key = ndb.StringProperty(default='')
  twitter_consumer_key = ndb.StringProperty(default='')
  twitter_consumer_secret = ndb.StringProperty(default='')

  _PROPERTIES = Base._PROPERTIES.union({
      'analytics_id',
      'brand_name',
      'feedback_email',
      'flask_secret_key',
      'google_api_key',
      'twitter_consumer_key',
      'twitter_consumer_secret',
    })


class User(Base, modelx.UserX):
  name = ndb.StringProperty(indexed=True, required=True)
  username = ndb.StringProperty(indexed=True, required=True)
  email = ndb.StringProperty(indexed=True, default='')
  auth_ids = ndb.StringProperty(indexed=True, repeated=True)

  active = ndb.BooleanProperty(default=True)
  admin = ndb.BooleanProperty(default=False)

  _PROPERTIES = Base._PROPERTIES.union({
      'active',
      'admin',
      'auth_ids',
      'avatar_url',
      'email',
      'name',
      'username',
    })
