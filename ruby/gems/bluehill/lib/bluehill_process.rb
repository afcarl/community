=begin

Bluehill = Flex/ActionScript code generation focusing on the Cairngorm framework.
Copyright 2010 by Chris Joakim.
Bluehill is available under GNU General Public License (GPL) license.

=end

module Bluehill
  
  class Process

    include Bluehill::Environment
    include Bluehill::InputOutput
  
    attr_reader :method_name, :subsystem, :tmp_dir, :start_time, :exception
    attr_reader :dispatch, :help_content, :system_test_commands

    def initialize(method_name_symbol, opts={})
      begin
        @start_time, @method_name = Time.now, method_name_symbol.to_s
        load_configuration
        if @method_name != 'help'
          puts "---" 
          puts "Beginning of Bluehill process: '#{method_name_symbol}'" 
        end
        self.send(method_name_symbol.to_s) # "dynamic dispatch" to the implementation method
      rescue Exception => e
        @exception = e
        puts "Exception in process #{process_info}"  
        puts "class:     #{e.class.name}"  
        puts "exception: #{e.inspect}"    
        if e.backtrace && e.backtrace.class == Array
          e.backtrace.each { | line | puts line }
        else
          puts e.backtrace
        end   
      ensure
        if @method_name != 'help'      
          end_time = Time.now     
          elapsed  = end_time - start_time
          minutes  = elapsed.to_f / 60.0
          hours    = elapsed.to_f / 3600.0
          puts "Process completed #{Time.now.to_s}." 
          puts sprintf("Elapsed seconds %6.6f = %5.6f minutes = %2.6f hours", elapsed, minutes, hours) 
          puts "---" 
        end
      end
    end
  
    def classname
      self.class.name
    end
  
    def process_info
      "'#{classname}.#{method_name.to_s}'"
    end
  
    def bluehill_home
      ENV['BLUEHILL_HOME']
    end
  
    def load_configuration
      config_file = command_line_arg('config', 'config/bluehill.config')
      Bluehill::Configuration.new(config_file)
      Bluehill::Properties.add('BLUEHILL_HOME', bluehill_home)
      Bluehill::Properties.add('projects', (ENV['projects'] ||= 'all'))
      display_properties if Bluehill::Properties.verbose?
    end
  
    def display_properties
      array = Bluehill::Properties.array_values
      array.each { | prop | puts "#{prop[0]} = #{prop[1]}"}
    
      hash = Bluehill::Properties.hash_values
      hash.keys.sort.each { | name |
        value = Bluehill::Properties.hash_values[name]
        puts sprintf("property: %-40s %s", name, value)
      }
    end
  
    def generate
      generator = Bluehill::Generator.new
      generator.generate_all
    end
  
  end
   
end