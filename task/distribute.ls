Assert = require \assert
Dir    = require \./constants .dir

module.exports =
  prepare: ->
    Assert.equal pwd!, Dir.DIST
    # package.json must reside in the /site npm package
    cp \-f, './package.json', Dir.dist.SITE
    mv \-f, './README.html', Dir.dist.SITE if test \-e './README.html'

  publish: ->
    false
