Assert  = require \assert
Choki   = require \chokidar
Cron    = require \cron
Emitter = require \events .EventEmitter
Fs      = require \fs
_       = require \lodash
Path    = require \path
Shell   = require \shelljs/global
WFib    = require \wait.for .launchFiber
W4      = require \wait.for .for
W4m     = require \wait.for .forMethod
Dir     = require \./constants .dir
Dirname = require \./constants .dirname
G       = require \./growl

const NMODULES = './node_modules'

pruner = new Cron.CronJob cronTime:'*/10 * * * *' onTick:prune-empty-dirs
tasks  =
  livescript:
    cmd : "#NMODULES/livescript/bin/lsc --output $OUT $IN"
    ixt : \ls
    oxt : \js
    xsub: 'json.js->json'

module.exports = me = (new Emitter!) with
  compile: ->
    try
      for tid of tasks then compile-batch tid
      me.emit \built
    catch e then G.err e

  refresh-modules: ->
    Assert.equal pwd!, Dir.BUILD
    W4 exec, 'npm -v', silent:false
    W4 exec, 'npm prune', silent:false
    W4 exec, 'npm install', silent:false

  start: ->
    G.say 'build started'
    try
      pushd Dir.ROOT
      for tid of tasks then start-watching tid
    finally
      popd!
    pruner.start!

  stop: ->
    pruner.stop!
    for , t of tasks then t.gaze?close!
    G.say 'build stopped'

## helpers

function compile t, ipath, cb
  Assert.equal pwd!, Dir.BUILD
  ipath-abs = Path.resolve Dir.ROOT, ipath
  mkdir \-p odir = Path.dirname opath = get-opath t, ipath
  switch typeof t.cmd
  | \string =>
    cmd = t.cmd.replace(\$IN "'#ipath-abs'").replace \$OUT "'#odir'"
    log cmd
    code, res <- exec cmd
    log code, res if code
    cb (if code then res else void), opath
  | \function =>
    e <- t.cmd ipath-abs, opath
    cb e, opath

function compile-batch tid
  t = tasks[tid]
  w = t.watcher._watched
  # https://github.com/paulmillr/chokidar/issues/281
  files = [ p-abs for p, v of w for f of v._items
    when test \-f p-abs = Path.join p, f ]
  info = "#{files.length} #tid files"
  G.say "compiling #info..."
  for f in files then W4 compile, t, Path.relative Dir.ROOT, f
  G.ok "...done #info!"

function get-opath t, ipath
  p = ipath.replace t.ixt, t.oxt if t.ixt?
  return p or ipath unless (xsub = t.xsub?split '->')?
  p.replace xsub.0, xsub.1

function prune-empty-dirs
  unless pwd! is Dir.BUILD then return log 'bypass prune-empty-dirs'
  code, out <- exec "find . -type d -empty -delete"
  G.err "prune failed: #code #out" if code

function start-watching tid
  log "start watching #tid"
  Assert.equal pwd!, Dir.ROOT
  pat = (t = tasks[tid]).pat or "*.#{t.ixt}"
  dirs = "#{Dirname.SITE},#{Dirname.TASK},#{Dirname.TEST}"
  w = t.watcher = Choki.watch [ "{#dirs}/**/#pat" pat ],
    cwd:Dir.ROOT
    ignoreInitial:true
    ignored:t.ignore
    persistent: false
  w.on \all process # _.debounce process, 500ms, leading:true trailing:false

  function process act, ipath
    log act, tid, ipath
    <- WFib
    switch act
    | \add \change
      try opath = W4 compile, t, ipath
      catch e then return G.err e
      G.ok opath
      me.emit \built
    | \unlink
      Assert.equal pwd!, Dir.BUILD
      try W4m Fs, \unlink opath = get-opath t, ipath
      catch e then throw e unless e.code is \ENOENT # not found i.e. already deleted
      G.ok "Delete #opath"
      me.emit \built
