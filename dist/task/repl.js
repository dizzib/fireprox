// Generated by LiveScript 1.2.0
(function(){
  var Chalk, Rl, Shell, WFib, Build, Dir, Dist, COMMANDS, i$, len$, c, x$, rl;
  global.log = console.log;
  Chalk = require('chalk');
  Rl = require('readline');
  Shell = require('shelljs/global');
  WFib = require('wait.for').launchFiber;
  Build = require('./build');
  Dir = require('./constants').dir;
  Dist = require('./distribute');
  cd(Dir.DIST);
  config.fatal = true;
  COMMANDS = [
    {
      cmd: 'h   ',
      desc: 'help  - show this help',
      fn: showHelp
    }, {
      cmd: 'b.fc',
      desc: 'build - files compile',
      fn: Build.compileFiles
    }, {
      cmd: 'b.nr',
      desc: 'build - npm refresh',
      fn: Build.refreshModules
    }, {
      cmd: 'd.NP',
      desc: 'dist  - npm publish',
      fn: Dist.publish
    }
  ];
  for (i$ = 0, len$ = COMMANDS.length; i$ < len$; ++i$) {
    c = COMMANDS[i$];
    c.display = Chalk.bold(c.cmd) + " " + c.desc;
  }
  x$ = rl = Rl.createInterface({
    input: process.stdin,
    output: process.stdout
  });
  x$.setPrompt("fireprox >");
  x$.on('line', function(cmd){
    return WFib(function(){
      var i$, ref$, len$, c;
      switch (cmd) {
      case '':
        return rl.prompt();
      default:
        for (i$ = 0, len$ = (ref$ = COMMANDS).length; i$ < len$; ++i$) {
          c = ref$[i$];
          if (cmd === c.cmd.trim()) {
            tryFn(c.fn);
          }
        }
        return rl.prompt();
      }
    });
  });
  Build.start();
  Build.on('built', Dist.prepare);
  setTimeout(showHelp, 1000);
  function showHelp(){
    var i$, ref$, len$, c;
    for (i$ = 0, len$ = (ref$ = COMMANDS).length; i$ < len$; ++i$) {
      c = ref$[i$];
      log(c.display);
    }
    return rl.prompt();
  }
  function tryFn(it){
    var e;
    try {
      return it();
    } catch (e$) {
      e = e$;
      return log(e);
    }
  }
}).call(this);