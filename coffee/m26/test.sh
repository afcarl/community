#!/bin/bash

# CoffeeScript compile and run tests shell script.

echo "compiling ..."
coffee -co test test

NODE_ENV=test
export NODE_ENV

echo "testing ..."  
mocha --reporter min --colors --require test/mocha_helper.js
