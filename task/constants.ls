Assert = require \assert
Shell  = require \shelljs/global

const ROOT = pwd!
const DIRNAME =
  BUILD: \_build
  SITE : \site
  TASK : \task
  TEST : \test
const DIR =
  BUILD: "#ROOT/#{DIRNAME.BUILD}"
  build:
    SITE: "#ROOT/#{DIRNAME.BUILD}/#{DIRNAME.SITE}"
    TEST: "#ROOT/#{DIRNAME.BUILD}/#{DIRNAME.TEST}"
  ROOT: "#ROOT"
  SITE: "#ROOT/#{DIRNAME.SITE}"
  TASK: "#ROOT/#{DIRNAME.TASK}"
  TEST: "#ROOT/#{DIRNAME.TEST}"

for dir in DIR then Assert test \-e dir

module.exports =
  dirname: DIRNAME
  dir    : DIR
