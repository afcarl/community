=begin

Bluehill = Flex/ActionScript code generation focusing on the Cairngorm framework.
Copyright 2010 by Chris Joakim.
Bluehill is available under GNU General Public License (GPL) license.

=end

require 'rubygems'
require 'rake'
# require 'cucumber/rake/task'

# The following prefixes /lib to the active ruby load path
$:.unshift File.join(File.dirname(__FILE__), "", "lib")

require 'bluehill'

# desc "Default Task; Display Bluehill properties."
# task :default => [ 'bluehill:display_properties'.to_sym ]

# Cucumber::Rake::Task.new do | t |
#   t.cucumber_opts = "--format pretty"
# end

namespace :bluehill do
  
  desc "Display parsed properties."
  task :display_properties do
    Bluehill::Process.new(:display_properties)
  end
    
  desc "Generate code and files."
  task :generate do
    Bluehill::Process.new(:generate)
  end  
  
end