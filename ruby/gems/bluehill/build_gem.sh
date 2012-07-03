#!/bin/bash

# Bluehill = Flex/ActionScript code generation focusing on the Cairngorm framework.
# Copyright 2010 by Chris Joakim.
# Bluehill is available under GNU General Public License (GPL) license.

env | grep RUBYOPT

touch bluehill-0.9.0.gem
rm    bluehill-0.9.0.gem

gem   build bluehill.gemspec

sudo gem uninstall bluehill

sudo gem install bluehill-0.9.0.gem

cp    bluehill-0.9.0.gem  /temp

cd    /temp

rm   -rf bluehill-0.9.0

gem   unpack bluehill-0.9.0.gem
