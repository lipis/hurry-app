hurry-app
=========

A countdown or countup app.

Examples
========

- [/2014-01-01](http://hurry-app.appspot.com/2014-01-01)
- [/2013-01-01-18:30](http://hurry-app.appspot.com/2014-01-01-18:30)
- [/2013-01-01/Happy New Year!](http://hurry-app.appspot.com/2014-01-01/Happy%20New%20Year!)
- [/1234567890](http://hurry-app.appspot.com/1234567890)
- [/1234567890/Unix Time](http://hurry-app.appspot.com/1234567890/Unix%20Time)
- [/1982-07-08-12:00/Lipis](http://hurry-app.appspot.com/1982-07-08-12:00/Lipis)


Running
-------
**hurry-app** is based on [gae-init](https://github.com/gae-init/gae-init) so
in order to run it you'll need to have installed [Google App Engine for
Python](https://developers.google.com/appengine/docs/python/) and
[node.js](http://nodejs.org).

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
To run the app:

    $ cd /path/to/hurry-app/main
    $ ./run.py -s

To test it visit `http://localhost:8080/` in your browser.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

To watch for changes of your `*.less` & `*.coffee` files and compile them
automatically to `*.css` & `*.js` run in another bash:

    $ ./run.py -w

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
To deploy the app on Google App Engine:

    $ ./run.py -m
    $ appcfg.py update .
