Express = require \express
Http    = require \http
Net     = require \net

log  = console.log
opts =
  host: get-env-var \MOZREPL_HOST, \localhost
  port: get-env-var \MOZREPL_PORT, 4242

(server = Express!).use allow-cross-domain
log "Fireprox connecting to MozRepl at #{opts.host}:#{opts.port}"

client = Net.connect opts, start
  ..on \data, -> log it.toString!

function start then
  log 'Connected!'
  server.get '/exec/:command', (req, res, next) ->
    log cmd = req.params.command
    client.on(\data, responder).write cmd

    function responder then
      const REPL-PROMPT = 'repl>'
      # to keep it simple, only the first packet is captured and returned
      client.removeListener \data, responder
      res.send it.toString!replace(REPL-PROMPT, '').trim!

  <- Http.createServer(server).listen (port = get-env-var \FIREPROX_PORT, 8080)
  log "Fireprox http server listening on port #{port}"

# http://backbonetutorials.com/cross-domain-sessions/
function allow-cross-domain req, res, next then
  res.set \Access-Control-Allow-Credentials, true
  res.set \Access-Control-Allow-Headers    , 'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version'
  res.set \Access-Control-Allow-Methods    , 'GET,POST,PUT,DELETE,OPTIONS'
  res.set \Access-Control-Allow-Origin     , req.headers.origin
  next!

function get-env-var name, value-default then
  log "env.#{name}=#{value = process.env[name]}"
  log "using default=#{value-default}" unless value
  value or value-default
