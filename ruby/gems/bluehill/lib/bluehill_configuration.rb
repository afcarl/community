=begin

Bluehill = Flex/ActionScript code generation focusing on the Cairngorm framework.
Copyright 2010 by Chris Joakim.
Bluehill is available under GNU General Public License (GPL) license.

---

This class translates the DSL of the configuration file entries into property
values held in class Bluehill::Properties.

=end
    
module Bluehill

  class Configuration
    
    def initialize(config_file)
      @in_globals_context      = false
      @in_project_list_context = false
      @in_project_context      = false
      @curr_project_name       = nil
      load_file(config_file)
    end
  
    def load_file(config_file)
      if File.exist?(config_file)
        File.open(config_file, 'r') do | config_file |
          config_file.read.each_line do | config_line |
            @tokens = config_line.strip.split
             if @tokens[0] == '*'
               handle_context
             elsif @tokens[0] == '-'
               handle_value
            end 
          end
        end
      else
        puts "properties file does not exist: #{config_file}"
      end
    end
  
    def handle_context
      if phrase_match?('* Bluehill will use these global configuration values:')
        @in_globals_context = true
      else
        @in_globals_context = false
      end
      if phrase_match?('* Bluehill will be used for these projects in your workspace:')
        @in_project_list_context = true
      else
        @in_project_list_context = false
      end 
      if phrase_match?('* Project ? will use these configuration values:')
        @in_project_context = true
        @curr_project_name  = @tokens[2]
      else
        @in_project_context = false
      end
    end
  
    def handle_value
      if @in_globals_context
        if phrase_match?('- Workspace directory is: ?')
          Bluehill::Properties.add('global_workspace_dir', last_token)
        
        elsif phrase_match?('- Verbose output is: ?')
          Bluehill::Properties.add('global_verbose', last_token)

        elsif phrase_match?('- Overwrite files is: ?')
          Bluehill::Properties.add('global_overwrite', last_token)

        elsif phrase_match?('- Create backup files is: ?')
          Bluehill::Properties.add('global_backup_files', last_token)
                            
        elsif phrase_match?('- Business delegate class template is: ?')
          Bluehill::Properties.add('global_delegate_template', last_token)

        elsif phrase_match?('- Command superclass template is: ?')
          Bluehill::Properties.add('global_command_superclass_template', last_token)
                
        elsif phrase_match?('- Command subclass template is: ?')
          Bluehill::Properties.add('global_command_template', last_token)

        elsif phrase_match?('- Delegate superclass template is: ?')
          Bluehill::Properties.add('global_delegate_superclass_template', last_token)
                
        elsif phrase_match?('- Delegate subclass template is: ?')
          Bluehill::Properties.add('global_delegate_template', last_token)
                  
        elsif phrase_match?('- Events class template is: ?')
          Bluehill::Properties.add('global_events_class_template', last_token)
        
        elsif phrase_match?('- Event class template is: ?')
          Bluehill::Properties.add('global_event_class_template', last_token)
        
        elsif phrase_match?('- FrontController class template is: ?')
          Bluehill::Properties.add('global_controller_template', last_token)
        
        elsif phrase_match?('- Services.mxml template is: ?')
          Bluehill::Properties.add('global_services_mxml_template', last_token)

        elsif phrase_match?('- Service result utility: ?')
          Bluehill::Properties.add('global_service_result_utility_template', last_token)
                  
        elsif phrase_match?('- Cairngorm Event class template is: ?')
          Bluehill::Properties.add('global_event_template', last_token)
        
        elsif phrase_match?('- ModelLocator interface template is: ?')
          Bluehill::Properties.add('global_model_locator_template', last_token)

        elsif phrase_match?('- Model interface template is: ?')
          Bluehill::Properties.add('global_model_template', last_token)
          
        elsif phrase_match?('- ValueObject superclass template is: ?')
          Bluehill::Properties.add('global_vo_superclass_template', last_token) 
                  
        elsif phrase_match?('- ValueObject class template is: ?')
          Bluehill::Properties.add('global_vo_template', last_token) 
          
        elsif phrase_match?('- View mxml template is: ?')
          Bluehill::Properties.add('global_view_template', last_token) 
                                           
        else
          puts "unmatched: #{@tokens.join(' ')}"
        end
      end
    
      if @in_project_list_context
        if phrase_match?('- Project: ?')
          Bluehill::Properties.add("project", @tokens[2])
        else
          puts "unmatched: #{@tokens.join(' ')}"
        end
      end
    
      if @in_project_context
        if phrase_match?('- Base ActionScript package: ?')
          Bluehill::Properties.add("#{@curr_project_name}_root_package", last_token)
        
        elsif phrase_match?('- Event triggers Command: ? invokes ? ?')
          name, type, svc = @tokens[4].downcase, @tokens[6], @tokens[7].downcase
          svc = name if svc == 'same'
          Bluehill::Properties.add("#{@curr_project_name}_event",     name)
          Bluehill::Properties.add("#{@curr_project_name}_command",   name)
          Bluehill::Properties.add("#{@curr_project_name}_command_svc_name_#{name}", svc)
          Bluehill::Properties.add("#{@curr_project_name}_command_svc_type_#{name}", type)

        elsif phrase_match?('- Event triggers Command: ? using Delegate ?')
          name, dname = @tokens[4].downcase, @tokens[7]
          dname = name if dname == 'same'
          Bluehill::Properties.add("#{@curr_project_name}_event",     name)
          Bluehill::Properties.add("#{@curr_project_name}_command",   name)
          Bluehill::Properties.add("#{@curr_project_name}_command_#{name}_delegate", dname)
                          
        elsif phrase_match?('- Event triggers Command: ?')
          command = @tokens[4].downcase
          Bluehill::Properties.add("#{@curr_project_name}_event",     command)
          Bluehill::Properties.add("#{@curr_project_name}_command",   command)
              
        elsif phrase_match?('- HTTPService default base url is: ?')
          Bluehill::Properties.add("#{@curr_project_name}_base_url", last_token)
        
        elsif phrase_match?('- HTTPService: ? ? ? ?')
          name = @tokens[2].downcase  
          Bluehill::Properties.add("#{@curr_project_name}_http_svc", name)
          Bluehill::Properties.add("#{@curr_project_name}_http_svc_#{name} method", @tokens[3])
          Bluehill::Properties.add("#{@curr_project_name}_http_svc_#{name} path",   @tokens[4])
          Bluehill::Properties.add("#{@curr_project_name}_http_svc_#{name} format", @tokens[5])

        elsif phrase_match?('- Delegate ? invokes ? ?')
          name, type, svc = @tokens[2].downcase, @tokens[4].downcase, @tokens[5].downcase
          svc = name if svc == 'same'
          Bluehill::Properties.add("#{@curr_project_name}_delegate", name)
          Bluehill::Properties.add("#{@curr_project_name}_delegate_svc_name_#{name}", svc)
          Bluehill::Properties.add("#{@curr_project_name}_delegate_svc_type_#{name}", type)
          
        elsif phrase_match?('- Model: ?')
          name = @tokens[2]
          Bluehill::Properties.add("#{@curr_project_name}_model", name)
                    
        elsif phrase_match?('- ValueObject: ?')
          name = @tokens[2]
          Bluehill::Properties.add("#{@curr_project_name}_vo", name)

        elsif phrase_match?('- View: ? inherits from ?')
          name, superclass = @tokens[2], @tokens[5]
          Bluehill::Properties.add("#{@curr_project_name}_view", "#{name} #{superclass}")
          
        else
          puts "unmatched: #{@tokens.join(' ')}"
        end
      end    
    end
  
    def phrase_match?(array_spec)
      array = array_spec.split
      return false if array.size != @tokens.size
      array.each_with_index { | word, idx |
        if word != '?'
          return false if array[idx] != @tokens[idx]
        end
      }
      true
    end
  
    def last_token
      @tokens[-1].strip
    end
  
  end
  
end
