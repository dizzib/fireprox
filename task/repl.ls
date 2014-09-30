global.log = console.log

Chalk = require \chalk
Args  = require \commander
_     = require \lodash
Rl    = require \readline
Shell = require \shelljs/global
WFib  = require \wait.for .launchFiber
Build = require \./build
Dir   = require \./constants .dir
Dist  = require \./distribute
Test  = require \./test

Args
  .option '--reggie-server-port [port]', 'reggie-server listening port for local publish'
  .parse process.argv

cd Dir.DIST # for safety, set working directory to /dist
config.fatal  = true # shelljs doesn't raise exceptions so kill this process on error
config.silent = true # otherwise too much noise

const CHALKS = [Chalk.stripColor, Chalk.yellow, Chalk.red]
const COMMANDS =
  * cmd:'h   ' level:0 desc:'help  - show this help'        fn:show-help
  * cmd:'b.fc' level:0 desc:'build - files compile'         fn:Build.compile-files
  * cmd:'b.nr' level:0 desc:'build - npm refresh'           fn:Build.refresh-modules
  * cmd:'t   ' level:0 desc:'test  - run'                   fn:Test.run
  * cmd:'d.lo' level:1 desc:'dist  - publish to local'      fn:Dist.publish-local
  * cmd:'d.PU' level:2 desc:'dist  - publish to public npm' fn:Dist.publish-public

max-level = if Args.reggie-server-port then 2 else 0
commands = _.filter COMMANDS, -> it.level <= max-level
for c in commands then c.display = "#{Chalk.bold CHALKS[c.level] c.cmd} #{c.desc}"

rl = Rl.createInterface input:process.stdin, output:process.stdout
  ..setPrompt "fireprox >"
  ..on \line, (cmd) -> WFib ->
    switch cmd
    | '' =>
      rl.prompt!
    | _  =>
      for c in commands when cmd is c.cmd.trim! then try-fn c.fn
      rl.prompt!

Build.start!
Build.on \built, Dist.prepare
setTimeout show-help, 1000ms

# helpers

function show-help
  for c in commands then log c.display
  rl.prompt!

function try-fn
  try it!
  catch e then log e
