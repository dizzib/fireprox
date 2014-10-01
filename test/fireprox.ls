# Fireprox tests
#
# Start a simple local http server (BOOP) and check
# we can interact with it via fireprox.

Chalk = require \chalk
Args  = require \commander
Http  = require \http
_     = require \lodash
Qs    = require \querystring
R     = require \request
T     = require \tape

const BOOP-PORT = 3000
const BOOP-HTML = "<html><body><p>It works!</p></body></html>"

log = console.log
Args.option '--port [port]' .parse process.argv

fpx-url  = "http://localhost:#{Args.port}"
boop-url = "http://localhost:#BOOP-PORT"

server = Http.createServer!
  ..on \request, (req, res) ->
    log "http server responding with #BOOP-HTML"
    res.end BOOP-HTML
  # For some unknown reason, setting location.href in mozrepl causes server.close! to timeout
  # So let's minimise the timeout until we figure what's happening
  ..timeout = 1000ms

T 'start BOOP', (t) ->
  t.plan 1
  <- server.listen BOOP-PORT
  err, res, body <- R boop-url
  t.equal body, BOOP-HTML # let's check it's running

T 'fireprox should say hello with firefox closed', (t) ->
  t.plan 1
  err, res, body <- R fpx-url
  t.equal body, 'Fireprox says hello!'

T 'navigate fireprox to BOOP', (t) ->
  function assert actual, expect then t.equal actual, "\"#expect\"" # mozrepl adds quotes
  function escape then it.replace /\//g, \%2f
  t.plan 4
  err, res, body <- R "#fpx-url/exec/content.location.href='#{escape boop-url}'"
  t.equal 200, res.statusCode
  assert body, boop-url
  <- _.delay _, 250ms
  <- R "#fpx-url/exec/repl.enter(content)"
  err, res, body <- R "#fpx-url/exec/document.querySelector('html').outerHTML"
  t.equal 200, res.statusCode
  expect = BOOP-HTML.replace '<html>', '<html><head></head>' # firefox adds head section
  assert body, expect

T 'stop BOOP', (t) ->
  server.close!
  t.end!
