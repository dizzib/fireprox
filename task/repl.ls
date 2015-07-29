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
  .option '--npm-local [dir]' 'local publish directory'
  .parse process.argv

cd Dir.BUILD # for safety, set working directory to BUILD
config.fatal  = true # shelljs doesn't raise exceptions so kill this process on error
config.silent = true # otherwise too much noise

const CHALKS = [Chalk.stripColor, Chalk.yellow, Chalk.red]
const COMMANDS =
  * cmd:'h   ' level:0 desc:'help  - show this help'        fn:show-help
  * cmd:'b.c ' level:0 desc:'build - compile'               fn:Build.compile
  * cmd:'b.nr' level:0 desc:'build - npm refresh'           fn:Build.refresh-modules
  * cmd:'    ' level:0 desc:'test  - run'                   fn:Test.run
  * cmd:'d.lo' level:1 desc:'dist  - publish to local dir'  fn:Dist.publish-local
  * cmd:'d.PU' level:2 desc:'dist  - publish to public npm' fn:Dist.publish-public

for c in COMMANDS then c.display = "#{Chalk.bold CHALKS[c.level] c.cmd} #{c.desc}"

rl = Rl.createInterface input:process.stdin, output:process.stdout
  ..setPrompt "fireprox >"
  ..on \line, (cmd) -> WFib ->
    for c in COMMANDS when cmd is c.cmd.trim!
      try c.fn!
      catch e then log e
    rl.prompt!

Build.start!
Build.on \built, ->
  Dist.prepare!
  Test.run!
setTimeout show-help, 1000ms

# helpers

function show-help
  for c in COMMANDS then log c.display
  rl.prompt!
