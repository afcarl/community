=begin

Bluehill = Flex/ActionScript code generation focusing on the Cairngorm framework.
Copyright 2010 by Chris Joakim.
Bluehill is available under GNU General Public License (GPL) license.

=end

require 'rubygems' 
require 'rake'

SPEC = Gem::Specification.new do | s |
  s.name                  = "bluehill" 
  s.version               = "0.9.0" 
  s.author                = "Chris Joakim" 
  s.email                 = "cjoakim@bellsouth.net" 
  s.homepage              = "http://rubyforge.org/projects/bluehill/" 
  s.platform              = Gem::Platform::RUBY
  s.rubyforge_project     = 'bluehill'
  s.description           = "Bluehill - a Flex/ActionScript code generator focusing on the Cairngorm framework."  
  s.summary               = "Bluehill - a Flex/ActionScript code generator focusing on the Cairngorm framework."
  s.require_paths         = ["lib"] 
  s.has_rdoc              = true 
  s.extra_rdoc_files      = ["README"]
  s.required_ruby_version = '>= 1.8.4'
  
  patterns = []
  patterns << 'config/bluehill.config'
  patterns << 'lib/**/*.rb'
  patterns << 'templates/*'  
  patterns << 'rakefile.rb'  
  s.files = FileList[patterns]
end 
