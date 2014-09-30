Chalk = require \chalk
Args  = require \commander
Http  = require \http
_     = require \lodash
Qs    = require \querystring
R     = require \request
T     = require \tape

log = console.log
Args.option '--port [port]' .parse process.argv
fpx-url = "http://localhost:#{Args.port}"

const PORT = 3000
const HTML = "<html><body><p>It works!</p></body></html>"
target-url = "http://localhost:#PORT"
server = Http.createServer!
  ..on \request, (req, res) ->
    log "http server responding with #HTML"
    res.end HTML
  # For some unknown reason, setting location.href in mozrepl causes server.close! to timeout
  # So let's minimise the timeout until we figure what's happening
  ..timeout = 1000ms

T 'start target http server', (t) ->
  t.plan 1
  <- server.listen PORT
  err, res, body <- R target-url
  t.equal body, HTML # let's check it's running

T 'fireprox should say hello!', (t) ->
  t.plan 1
  err, res, body <- R fpx-url
  t.equal body, 'Fireprox says hello!'

T 'navigate fireprox to target', (t) ->
  function assert actual, expect then t.equal actual, "\"#expect\"" # mozrepl adds quotes
  function escape then it.replace /\//g, \%2f
  t.plan 4
  err, res, body <- R "#fpx-url/exec/content.location.href='#{escape target-url}'"
  t.equal 200, res.statusCode
  assert body, target-url
  <- _.delay _, 250ms
  <- R "#fpx-url/exec/repl.enter(content)"
  err, res, body <- R "#fpx-url/exec/document.querySelector('html').outerHTML"
  t.equal 200, res.statusCode
  expect = HTML.replace '<html>', '<html><head></head>' # firefox adds head section
  assert body, expect

T 'stop target http server', (t) ->
  server.close!
  t.end!
