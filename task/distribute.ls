Assert = require \assert
Args   = require \commander
Shell  = require \shelljs/global
W4     = require \wait.for .for
Dir    = require \./constants .dir

module.exports =
  prepare: ->
    cp \-rf "#{Dir.SITE}/bin/*" "#{Dir.build.SITE}/bin"
    cp \-f "#{Dir.BUILD}/package.json" Dir.build.SITE

  publish-local: ->
    throw new Error 'please specify local dir on command line' unless dest = Args.npm-local
    log "publish to local #dest"
    rm \-rf dest
    cp \-r "#{Dir.build.SITE}/*" dest

  publish-public: ->
    pushd Dir.build.SITE
    try
      W4 exec, "npm publish", silent:false
    finally
      popd!
