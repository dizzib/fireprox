A simple proxy for [MozRepl] over HTTP-GET using [express]/[node.js] to control Firefox:

    browser/client <--HTTP-GET--> fireprox <----> MozRepl/Firefox

I threw this together because I needed an easy way to programatically read the current
url from Firefox into my javascript web application [WhoDoTheyServe.com][wdts]
but was unable to workaround browser security restrictions or get
[Firefox WebDriver][WebDriver] to work reliably.

## To Install and Run

    npm install fireprox

Optional configuration:

    export MOZREPL_HOST=<MozRepl host name or ip, default=localhost>
    export MOZREPL_PORT=<MozRepl port, default=4242>
    export FIREPROX_PORT=<Fireprox port, default=8080>

To start:

    cd node_modules/fireprox
    npm start

If all goes well you should see the MozRepl welcome message.

## Usage

Point your browser to `http://fireprox:8080/exec/COMMAND` where `fireprox:8080` is the node.js server running fireprox and `COMMAND` is any MozRepl command.

## Examples

To get the firefox current url browse to `http://fireprox:8080/exec/content.location.href`

To show `foo` in an alert box browse to `http://fireprox:8080/exec/alert('foo')`
(note you'll need to manually close this alert before fireprox returns).

## To clone, build and run locally

    git clone git@github.com:dizzib/fireprox.git

    npm install -g livescript   # ensure livescript is installed globally
    ./task/bootstrap            # compile the scripts and install dependencies
    node dist/task/repl         # run the build scripts
    b.fc                        # compile everything

Then to run it from another terminal:

    node dist/site/server

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
