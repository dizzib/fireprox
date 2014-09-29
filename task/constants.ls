Assert = require \assert
Shell  = require \shelljs/global

const ROOT = pwd!
const DIRNAME =
  DIST: \dist
  SITE: \site
  TASK: \task
  TEST: \test
const DIR =
  DIST: "#ROOT/#{DIRNAME.DIST}"
  dist:
    SITE: "#ROOT/#{DIRNAME.DIST}/#{DIRNAME.SITE}"
  ROOT: "#ROOT"
  SITE: "#ROOT/#{DIRNAME.SITE}"
  TASK: "#ROOT/#{DIRNAME.TASK}"
  TEST: "#ROOT/#{DIRNAME.TEST}"

for dir in DIR then Assert test \-e dir

module.exports =
  dirname: DIRNAME
  dir    : DIR
