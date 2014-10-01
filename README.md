A simple proxy for [MozRepl] over HTTP-GET using [express]/[node.js] to control Firefox:

    browser or client <--HTTP-GET--> fireprox <----> MozRepl + Firefox

I threw this together because I needed an easy way to programatically read the current
url from Firefox into my javascript web application [WhoDoTheyServe.com][wdts]
but was unable to workaround browser security restrictions or get
[Firefox WebDriver][WebDriver] to work reliably.

## To Install and Run

    $ npm install fireprox
    $ cd node_modules/fireprox
    $ node fireprox

Options:

    $ node fireprox --help

    Usage: fireprox [options]

    Options:

      -h, --help             output usage information
      -V, --version          output the version number
      -p, --port [port]      fireprox listening port (default:8080)
      --mozrepl-host [host]  mozrepl hostname or ip-address (default:localhost)
      --mozrepl-port [port]  mozrepl port (default:4242)

## Usage

To check fireprox is running navigate to `http://fireprox:8080` where `fireprox:8080` is
the node.js server running fireprox. You should see `Fireprox says hello!`.

Now navigate to `http://fireprox:8080/COMMAND` where `COMMAND` is any MozRepl command.

## Examples

To get the firefox current url browse to `http://fireprox:8080/content.location.href`

To navigate firefox to `http://bar` browse to `http://fireprox:8080/content.location.href='http:%2f%2fbar'`
(notice the escaped //)

To show `foo` in an alert box browse to `http://fireprox:8080/alert('foo')`
(note you'll need to manually close this alert before fireprox returns).

## To clone, build and run locally

    $ git clone git@github.com:dizzib/fireprox.git

    $ npm install -g livescript   # ensure livescript is installed globally
    $ ./task/bootstrap            # compile the scripts and install dependencies
    $ node dist/task/repl         # launch the task runner
    fireprox > b.fc               # compile everything

To run your newly built fireprox:

    $ node dist/site/server

## Credits

Inspired by [codediesel].

## License

MIT

[codediesel]: http://www.codediesel.com/tools/peeking-inside-firefox-using-mozrepl
[express]: https://github.com/visionmedia/express
[LiveScript]: https://github.com/gkz/LiveScript
[MozRepl]: https://github.com/bard/mozrepl/wiki
[node.js]: http://nodejs.org
[wdts]: http://WhoDoTheyServe.com
[WebDriver]: http://code.google.com/p/selenium/wiki/FirefoxDriver
