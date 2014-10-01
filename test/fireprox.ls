# Fireprox tests
#
# Start a simple local http server BOOP and check
# we can interact with it via fireprox.

Chalk  = require \chalk
Cp     = require \child_process
Args   = require \commander
Http   = require \http
HttpSt = require \http-status
_      = require \lodash
R      = require \request
T      = require \tape

const BOOP-HTML = "<html><body><p>It works!</p></body></html>"
const BOOP-PORT = 3000

log = console.log
Args.option '--port [port]' .parse process.argv

firefox  = void
fpx-url  = "http://localhost:#{Args.port}"
boop-url = "http://localhost:#BOOP-PORT"

server = Http.createServer!
  ..on \request, (req, res) ->
    log "http server responding with #BOOP-HTML"
    res.end BOOP-HTML
  # For some unknown reason, setting location.href in mozrepl causes server.close! to timeout
  # So let's minimise the timeout until we figure what's happening
  ..timeout = 1000ms

req = R.defaults timeout:5000ms

T 'kill existing firefoxes', (t) ->
  # NOTE! Killing firefox via SIGTERM makes it grumble on next launch.
  # https://bugzilla.mozilla.org/show_bug.cgi?id=336193
  <- Cp.exec 'pkill firefox'
  <- _.delay _, 1000ms # give firefox a chance to close
  t.end!

T 'start BOOP', (t) ->
  t.plan 1
  <- server.listen BOOP-PORT
  err, res, body <- req boop-url
  t.equal body, BOOP-HTML # let's check it's running

T 'fireprox should say hello before firefox is opened', check-fireprox-says-hello
T 'using fireprox before firefox is opened should error', check-fireprox-bad-gateway

T 'start firefox and ensure MozRepl is listening', (t) ->
  function log-firefox then log "FIREFOX: #{it.toString!}"
  firefox := Cp.spawn \firefox
    ..stderr.on \data, log-firefox
    ..stdout.on \data, ->
      log-firefox it
      t.end! if /MOZREPL : Listening/.test it

T 'navigate firefox to BOOP', (t) ->
  function assert actual, expect then t.equal actual, "\"#expect\"" # mozrepl adds quotes
  function escape then it.replace /\//g, \%2f
  t.plan 4
  err, res, body <- req "#fpx-url/content.location.href='#{escape boop-url}'"
  t.equal res?statusCode, HttpSt.OK
  assert body, boop-url
  <- req "#fpx-url/repl.enter(content)"
  err, res, body <- req "#fpx-url/document.querySelector('html').outerHTML"
  t.equal res?statusCode, HttpSt.OK
  expect = BOOP-HTML.replace '<html>', '<html><head></head>' # firefox adds head section
  assert body, expect

T 'kill firefox', (t) ->
  # NOTE! Killing firefox via SIGTERM makes it grumble on next launch.
  # https://bugzilla.mozilla.org/show_bug.cgi?id=336193
  firefox?kill!
  <- _.delay _, 500ms # give firefox a chance to close
  t.end!

T 'fireprox should say hello after firefox is closed', check-fireprox-says-hello
T 'using fireprox after firefox is closed should error', check-fireprox-bad-gateway

T 'stop BOOP', (t) ->
  server.close!
  t.end!

## helpers

function check-fireprox-bad-gateway t
  t.plan 1
  err, res, body <- req "#fpx-url/content.location.href"
  log err, body
  t.equal res?statusCode, HttpSt.BAD_GATEWAY

function check-fireprox-says-hello t
  t.plan 1
  err, res, body <- req fpx-url
  t.equal body, 'Fireprox says hello!'
