m26
===

Copyright 2012, Chris Joakim, <cjoakim@bellsouth.net>.

M26 is my CoffeeScript library for running, cycling, and swimming
calculations, such as for marathon running.  The name means "mile 26".

Average pace per mile/km/yard can be calculated, and times can be interpolated
or extrapolated to another distance using either a simple or Riegel (exponential)
formula.

Node.js is used as the JavaScript engine and CoffeeScript compiler.


Instructions for use on Apple OS X:
-----------------------------------

- Install npm:
  - curl http://npmjs.org/install.sh | sh
  - which npm    -> /usr/local/bin/npm
  - npm -v       -> 1.1.37

- Install node with homebrew:
  - brew doctor  -> Your system is raring to brew.
  - brew install node
  - which node   -> /usr/local/bin/node
  - node -v      -> v0.8.2

- Install the mocha test framework globall; it adds the 'mocha' program.
  - npm install -g mocha
  - npm install   (install node packages per the 'package.json' file)

- Compiling the CoffeeScript to JavaScript:
  - cake build    (one-time compile)
  - cake watch    (watches the cs/ directory, and compiles upon file changes)

- Executing the unit tests:
  - npm test     ->  ✔ 21 tests complete (8ms)
