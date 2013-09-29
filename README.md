hurry-app
=========

A web app which based on a url given date-time visualizes the remaining time
till that moment in seconds, minutes, hours, days, weeks, months and years.

It's good for launch dates, milestones, birthdays, anniversaries, you
name it..

[http://hurry-app.appspot.com](http://hurry-app.appspot.com)


Examples
--------

- [/2014-01-01](http://hurry-app.appspot.com/2014-01-01)
- [/2013-01-01-18:30](http://hurry-app.appspot.com/2014-01-01-18:30)
- [/12:34](http://hurry-app.appspot.com/12:34)
- [/12:34/Final](http://hurry-app.appspot.com/12:34/Final)
- [/2013-01-01/Happy New Year!](http://hurry-app.appspot.com/2014-01-01/Happy%20New%20Year!)
- [/1955-10-28/Bill Gates](http://hurry-app.appspot.com/1955-10-28/Bill%20Gates)

(All input times are in UTC)

Running
-------
**hurry-app** is based on [gae-init](https://github.com/gae-init/gae-init) so
to run it locally you'll need to have installed [Google App Engine for
Python](https://developers.google.com/appengine/docs/python/) and
[node.js](http://nodejs.org).

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
To run the app:

    $ cd /path/to/hurry-app
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
