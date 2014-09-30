name       : \fireprox
description: "A simple proxy for MozRepl over HTTP GET using express/nodejs"
version    : \0.3.0
author     : \dizzib
license:   : \MIT
keywords   : <[ control firefox get http mozrepl node nodejs proxy ]>
repository :
  type: \git
  url : \https://github.com/dizzib/fireprox
scripts:
  start: "node server.js"
engines:
  node: \>=0.8.x
  npm : \>=1.0.x
dependencies:
  express: \3.1.0
devDependencies:
  chalk     : \~0.4.0
  cron      : \~1.0.3
  gaze      : \~0.6.4
  globule   : \~0.2.0 # TODO: remove when gaze fixes issue 104
  gntp      : \~0.1.1
  LiveScript: \~1.2.0
  lodash    : \~2.4.1
  marked    : \~0.3.1
  shelljs   : \~0.2.6
  'wait.for': \~0.6.3
  yargs     : \~1.3.1
