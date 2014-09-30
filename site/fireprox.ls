Args    = require \commander
Express = require \express
Http    = require \http
Net     = require \net
P-Json  = require \./package.json

log = console.log

const PORT = 8080
const MOZREPL-HOST = \localhost
const MOZREPL-PORT = 4242

Args
  .version P-Json.version
  .option '-p, --port [port]', "fireprox listening port (default:#PORT)", PORT
  .option '--mozrepl-host [host]', "mozrepl hostname or ip-address (default:#MOZREPL-HOST)", MOZREPL-HOST
  .option '--mozrepl-port [port]', "mozrepl port (default:#MOZREPL-PORT)", MOZREPL-PORT
  .parse process.argv

(express = Express!).use allow-cross-domain
net-cfg = host:Args.mozrepl-host, port:Args.mozrepl-port
log "Fireprox connecting to MozRepl at #{net-cfg.host}:#{net-cfg.port}"

client = Net.connect net-cfg, start
  ..on \data, -> log it.toString!

function start
  log 'Fireprox connected to MozRepl!'
  express
    ..get '/', (req, res, next) ->
      log msg = 'Fireprox says hello!'
      res.send msg
    ..get '/exec/:command', (req, res, next) ->
      log cmd = req.params.command
      client.on(\data, responder).write cmd

      function responder
        const REPL-PROMPT = 'repl>'
        # to keep it simple only the first packet is captured and returned
        client.removeListener \data, responder
        res.send it.toString!replace(REPL-PROMPT, '').trim!

  log "Creating fireprox listening on port #{Args.port}"
  <- Http.createServer(express).listen Args.port
  log "Fireprox listening on port #{Args.port}"

# http://backbonetutorials.com/cross-domain-sessions/
function allow-cross-domain req, res, next
  res.set \Access-Control-Allow-Credentials, true
  res.set \Access-Control-Allow-Headers    , 'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version'
  res.set \Access-Control-Allow-Methods    , 'GET,POST,PUT,DELETE,OPTIONS'
  res.set \Access-Control-Allow-Origin     , req.headers.origin
  next!
