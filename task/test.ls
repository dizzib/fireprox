Chalk = require \chalk
Cp    = require \child_process
Shell = require \shelljs/global
W4    = require \wait.for .for
Dir   = require \./constants .dir

const FIREPROX-PORT = 8888

module.exports =
  run: ->
    try
      fpx = W4 run-fireprox
      W4 run-tests
    finally
      fpx?kill!

function run-fireprox cb
  function log-fpx then log Chalk.yellow it.toString!
  pushd Dir.dist.SITE
  try
    log opts = [ \fireprox \--port FIREPROX-PORT ]
    fpx = Cp.spawn \node, opts
      ..stderr.on \data, log-fpx
      ..stdout.on \data, ->
        log-fpx it
        cb null, fpx if /Fireprox listening on port/.test it
  finally
    popd!

function run-tests cb
  pushd Dir.dist.TEST
  try
    Cp.spawn \node, [ \fireprox \--port FIREPROX-PORT ]
      ..on \close, cb
      ..stderr.on \data, -> log it.toString!
      ..stdout.on \data, -> log it.toString!
  finally
    popd!
