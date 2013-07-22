A simple proxy for [MozRepl] over HTTP GET using [express]/[nodejs],
to control Firefox:

    Any browser/client <--> fireprox <--> MozRepl <--> Firefox

I threw this together because I needed an easy way to programatically read the current
url from Firefox into my javascript web application [WhoDoTheyServe.com][wdts],
but was unable to workaround browser security restrictions or get
[Firefox WebDriver][WebDriver] to work reliably.

## To Install and Run

Clone the repo, compile the [LiveScript] files to javascript/json, then:

    npm install
    npm start

You should see the MozRepl welcome message.

## Usage

Point any browser/client to `http://fireprox:8080/exec/COMMAND` where:

  `fireprox:8080` is the nodejs server running fireprox

  `COMMAND` is any MozRepl command

## Examples

To get the firefox current url, browse to:

    http://fireprox:8080/exec/content.location.href

To show 'foo' in an alert box, browse to:

    http://fireprox:8080/exec/alert('foo')

## Configuration

Use the following environment variables to configure fireprox:

`MOZREPL_HOST`: The MozRepl host name or ip. Default is localhost.

`MOZREPL_PORT`: The MozRepl host port. Default is 4242.

`PORT`: The fireprox host port. Default is 8080.

## Credits

Inspired by [codediesel].

## License

MIT

[codediesel]: http://www.codediesel.com/tools/peeking-inside-firefox-using-mozrepl
[express]: https://github.com/visionmedia/express
[LiveScript]: https://github.com/gkz/LiveScript 
[MozRepl]: https://github.com/bard/mozrepl/wiki
[nodejs]: http://nodejs.org
[wdts]: http://WhoDoTheyServe.com
[WebDriver]: http://code.google.com/p/selenium/wiki/FirefoxDriver
