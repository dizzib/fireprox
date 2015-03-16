## fireprox

A simple proxy for [MozRepl] over HTTP-GET using [express]/[node.js] to control Firefox:

    browser or client <--HTTP-GET--> fireprox <----> MozRepl + Firefox

I threw this together because I needed an easy way to programatically read the current
url from a remote Firefox into [my javascript web application][wdts]
but was unable to workaround browser security restrictions or get
[Firefox WebDriver][WebDriver] to work reliably.

## install and run

    $ npm install -g fireprox     # might need to prefix with sudo
    $ fireprox

## options

    $ node fireprox --help
    Usage: fireprox [options]

    Options:

      -h, --help                 output usage information
      -V, --version              output the version number
      -p, --port [port]          fireprox listening port (default:8080)
      -m, --mozrepl-host [host]  mozrepl hostname or ip-address (default:localhost)
      -q, --mozrepl-port [port]  mozrepl port (default:4242)

## usage

Navigate to `http://server:8080` where `server` is
the node.js server running fireprox. You should see `Fireprox says hello!`.

Now navigate to `http://server:8080/COMMAND` where `COMMAND` is any MozRepl command.

## examples

To get the firefox current url browse to `http://server:8080/content.location.href`

To navigate firefox to `http://bar` browse to `http://server:8080/content.location.href='http:%2f%2fbar'`
(notice the escaped //)

To show `foo` in an alert box browse to `http://server:8080/alert('foo')`
(you'll need to manually close this alert before fireprox returns).

## build and run locally

    $ npm install -g livescript   # ensure livescript is installed globally
    $ git clone git@github.com:dizzib/fireprox.git
    $ cd fireprox
    $ ./task/bootstrap            # compile the task runner and install dependencies
    $ node _build/task/repl       # launch the task runner
    fireprox > b.c                # build compile

    $ ./_build/site/bin/fireprox  # run it!

## credits

Inspired by [codediesel].

## license

MIT

[codediesel]: http://www.codediesel.com/tools/peeking-inside-firefox-using-mozrepl
[express]: https://github.com/visionmedia/express
[LiveScript]: https://github.com/gkz/LiveScript
[MozRepl]: https://github.com/bard/mozrepl/wiki
[node.js]: http://nodejs.org
[wdts]: http://WhoDoTheyServe.com
[WebDriver]: http://code.google.com/p/selenium/wiki/FirefoxDriver
