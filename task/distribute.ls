Assert = require \assert
Shell  = require \shelljs/global
W4     = require \wait.for .for
Argv   = require \yargs .argv
Dir    = require \./constants .dir

module.exports =
  prepare: ->
    Assert.equal pwd!, Dir.DIST
    cp \-f, './package.json', Dir.dist.SITE
    mv \-f, './README.html', Dir.dist.SITE if test \-e './README.html'

  publish-local: ->
    pushd Dir.dist.SITE
    try
      port = argv.reggie-server-port
      W4 exec, "reggie -u http://localhost:#port publish"
    finally
      popd!

  publish-public: ->
    pushd Dir.dist.SITE
    try
      log 'TODO!'
    finally
      popd!
