global.log = console.log

Chalk = require \chalk
Rl    = require \readline
Shell = require \shelljs/global
WFib  = require \wait.for .launchFiber
Build = require \./build
Dir   = require \./constants .dir
Dist  = require \./distribute

cd Dir.DIST # for safety, set working directory to /dist
config.fatal = true # shelljs doesn't raise exceptions so kill this process on error

const COMMANDS =
  * cmd:'h   ' desc:'help  - show this help' fn:show-help
  * cmd:'b.fc' desc:'build - files compile'  fn:Build.compile-files
  * cmd:'b.nr' desc:'build - npm refresh'    fn:Build.refresh-modules
  * cmd:'d.NP' desc:'dist  - npm publish'    fn:Dist.publish

for c in COMMANDS then c.display = "#{Chalk.bold c.cmd} #{c.desc}"

rl = Rl.createInterface input:process.stdin, output:process.stdout
  ..setPrompt "fireprox >"
  ..on \line, (cmd) -> WFib ->
    switch cmd
    | '' =>
      rl.prompt!
    | _  =>
      for c in COMMANDS when cmd is c.cmd.trim! then try-fn c.fn
      rl.prompt!

Build.start!
Build.on \built, Dist.prepare
setTimeout show-help, 1000ms

# helpers

function show-help
  for c in COMMANDS then log c.display
  rl.prompt!

function try-fn
  try it!
  catch e then log e
