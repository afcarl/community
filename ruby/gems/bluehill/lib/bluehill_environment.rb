=begin

Bluehill = Flex/ActionScript code generation focusing on the Cairngorm framework.
Copyright 2010 by Chris Joakim.
Bluehill is available under GNU General Public License (GPL) license.

=end

module Bluehill
  
  module Environment

    def command_line_arg(arg_name, default_value=nil)
      value = ENV[arg_name]  
      (value.nil?) ? default_value : value
    end
  
    def boolean_param(name, default=false)
      value = ENV[name.to_s]
      return default if value.nil?
      return true  if (value.downcase == 'true')  || (value.downcase == 't')
      return false if (value.downcase == 'false') || (value.downcase == 'f')
      default  
    end
  
    def integer_param(name, default=0)
      (ENV[name.to_s]) ? ENV[name.to_s].to_i : default.to_i
    end
  
    def float_param(name, default=0.0)
      (ENV[name.to_s]) ? ENV[name.to_s].to_f : default.to_f
    end  
  
    def string_param(name, default='')
      (ENV[name.to_s]) ? ENV[name.to_s] : default.to_s
    end 
  
    def array_param(name, default=[])
      array = []    
      csv_value = string_param(name.to_s, nil)
      if csv_value
        FasterCSV.parse(csv_value) do | row |
          row.each { | value | array << value }
        end
        array
      else
        default
      end
    end 
  
  end
  
end