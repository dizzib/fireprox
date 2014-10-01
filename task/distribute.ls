Assert = require \assert
Args   = require \commander
Shell  = require \shelljs/global
W4     = require \wait.for .for
Dir    = require \./constants .dir

module.exports =
  prepare: ->
    Assert.equal pwd!, Dir.DIST
    cp \-f, './package.json', Dir.dist.SITE
    mv \-f, './README.html', Dir.dist.SITE if test \-e './README.html'

  publish-local: ->
    pushd Dir.dist.SITE
    try
      port = Args.reggie-server-port
      W4 exec, "reggie -u http://localhost:#port publish", silent:false
    finally
      popd!

  publish-public: ->
    pushd Dir.dist.SITE
    try
      W4 exec, "npm publish", silent:false
    finally
      popd!
