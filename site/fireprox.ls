Args    = require \commander
Express = require \express
Http    = require \http
HttpSt  = require \http-status
_       = require \lodash
Net     = require \net
P-Json  = require \./package.json

log = console.log

const MOZREPL-HOST      = \localhost
const MOZREPL-PORT      = 4242
const MOZREPL-PROMPT    = 'repl>'
const MOZREPL-PROMPT-RX = new RegExp "\n#MOZREPL-PROMPT $"
const PORT              = 8080

Args
  .version P-Json.version
  .option '-p, --port [port]', "fireprox listening port (default:#PORT)", PORT
  .option '-m, --mozrepl-host [host]', "mozrepl hostname or ip-address (default:#MOZREPL-HOST)", MOZREPL-HOST
  .option '-q, --mozrepl-port [port]', "mozrepl port (default:#MOZREPL-PORT)", MOZREPL-PORT
  .parse process.argv

function allow-cross-domain req, res, next # http://backbonetutorials.com/cross-domain-sessions/
  res.set \Access-Control-Allow-Credentials, true
  res.set \Access-Control-Allow-Headers    , 'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version'
  res.set \Access-Control-Allow-Methods    , 'GET,POST,PUT,DELETE,OPTIONS'
  res.set \Access-Control-Allow-Origin     , req.headers.origin
  next!

var client
net-cfg = host:Args.mozrepl-host, port:Args.mozrepl-port

(express = Express!).use allow-cross-domain
  ..get '/', (req, res, next) -> # TIP: to check fireprox is running manually navigate to /
    log msg = 'Fireprox says hello!'
    res.send msg

  ..get '/:command', (req, res, next) ->
    log cmd = req.params.command
    return send-and-reply! if client

    log "Fireprox connecting to MozRepl at #{net-cfg.host}:#{net-cfg.port}"
    client := Net.connect net-cfg # lazy connection
      ..on \close, ->
        log 'socket.close'
        client := null
      ..on \connect, ->
        log 'Fireprox connected to MozRepl!'
      ..on \data, skip-welcome
      ..on \error, -> # e.g. cannot connect
        log s = it.toString!
        res.send s, HttpSt.BAD_GATEWAY

    function send-and-reply
      <- _.delay _, 250ms # mozrepl sometimes gives 'Host context unloading!' without this (yay!)
      client.on(\data, responder).write cmd
      buffer = ''
      function responder # add packets to buffer til we see the prompt
        buffer += it.toString!
        return unless MOZREPL-PROMPT-RX.test buffer
        client.removeListener \data, responder
        res.send buffer.replace(MOZREPL-PROMPT-RX, '').trim!
        buffer := ''

    function skip-welcome
      log it.toString!
      return unless MOZREPL-PROMPT-RX.test it
      client.removeListener \data, skip-welcome
      <- _.delay _, 250ms # allow mozrepl to settle
      send-and-reply!

log "Creating fireprox listening on port #{Args.port}"
<- Http.createServer(express).listen Args.port
log "Fireprox listening on port #{Args.port}"
