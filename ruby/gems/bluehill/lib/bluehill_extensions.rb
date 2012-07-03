=begin

Bluehill = Flex/ActionScript code generation focusing on the Cairngorm framework.
Copyright 2010 by Chris Joakim.
Bluehill is available under GNU General Public License (GPL) license.

=end

class String
  
  def to_camel_case
    word = self.tr('_', ' ')
    word.gsub!(/^[a-z]|\s+[a-z]/) { |a| a.upcase }
    word.gsub!(/\s/, '')
    word
  end
    
end