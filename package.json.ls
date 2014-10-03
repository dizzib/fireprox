name       : \fireprox
description: "A simple proxy for MozRepl over HTTP GET using express/node.js to control Firefox"
version    : \1.0.3
author     : \dizzib
license:   : \MIT
keywords   : <[ control firefox get http mozrepl node nodejs proxy remote ]>
repository :
  type: \git
  url : \https://github.com/dizzib/fireprox
engines:
  node: \>=0.8.x
  npm : \>=1.0.x
dependencies:
  express      : \3.1.0
  commander    : \2.3.0
  'http-status': \0.1.8
  lodash       : \2.4.1
devDependencies:
  chalk     : \~0.4.0
  cron      : \~1.0.3
  gaze      : \~0.6.4
  globule   : \~0.2.0 # TODO: remove when gaze fixes issue 104
  gntp      : \~0.1.1
  LiveScript: \~1.2.0
  marked    : \~0.3.1
  request   : \~2.44.0
  shelljs   : \~0.2.6
  tape      : \~3.0.0
  'wait.for': \~0.6.3
