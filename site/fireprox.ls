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
const MOZREPL-PROMPT-RX = new RegExp "#MOZREPL-PROMPT $"
const PORT              = 8080

Args
  .version P-Json.version
  .option '-p, --port [port]', "fireprox listening port (default:#PORT)", PORT
  .option '--mozrepl-host [host]', "mozrepl hostname or ip-address (default:#MOZREPL-HOST)", MOZREPL-HOST
  .option '--mozrepl-port [port]', "mozrepl port (default:#MOZREPL-PORT)", MOZREPL-PORT
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
  ..get '/', (req, res, next) -> # you can navigate to / to check fireprox is running
    log msg = 'Fireprox says hello!'
    res.send msg
  ..get '/exec/:command', (req, res, next) ->
    log cmd = req.params.command
    return send! if client
    # connect lazily
    log "Fireprox connecting to MozRepl at #{net-cfg.host}:#{net-cfg.port}"
    var send-on-prompt
    client := Net.connect net-cfg
      ..on \close, ->
        log 'socket.close'
        client := null
      ..on \connect, ->
        log 'Fireprox connected to MozRepl!'
        send-on-prompt := true # ensure cmd is sent at prompt after welcome messages
      ..on \data, ->
        log it.toString!
        return unless MOZREPL-PROMPT-RX.test it
        return unless send-on-prompt
        send-on-prompt := false
        <- _.delay _, 250ms # allow mozrepl to settle down otherwise we get an error
        send!
      ..on \error, -> # e.g. cannot connect
        log s = it.toString!
        res.send s, HttpSt.BAD_GATEWAY

    function send
      client.on \data, responder
      client.write cmd

    function responder
      # to keep it simple only the first packet is captured and returned
      # Yes this is horrible 'cos subsequent packets may still be arriving
      client.removeListener \data, responder
      res.send it.toString!replace(MOZREPL-PROMPT, '').trim!

log "Creating fireprox listening on port #{Args.port}"
<- Http.createServer(express).listen Args.port
log "Fireprox listening on port #{Args.port}"
