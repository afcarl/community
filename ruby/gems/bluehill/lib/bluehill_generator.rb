=begin

Bluehill = Flex/ActionScript code generation focusing on the Cairngorm framework.
Copyright 2010 by Chris Joakim.
Bluehill is available under GNU General Public License (GPL) license.

=end

module Bluehill
  
  class Generator
  
    include Bluehill::InputOutput
    
    attr_reader :project_list, :project_name, :workspace_dir, :root_package
  
    def initialize
      @project_list   = Bluehill::Properties.project_list
      @workspace_dir  = Bluehill::Properties.get_property('global_workspace_dir')
      
      t  = Time.now
      on = t.strftime("%a %Y/%m/%d")
      at = t.strftime("%I:%M%p")
      @time_generated = "on #{on} at #{at}"
    end

    def generate_all(create_files=true)
      reset_generation_counts
      @project_list.each { | name | 
          generate_project(name, create_files) 
      }
      display_generation_counts
    end
  
    def generate_project(proj_name, create_files=true)
      @project_name = proj_name
      define_project_variables
      if create_files
        create_project_directories      
        generate_services_mxml
        generate_service_result_utility
        generate_events_class
        generate_events  
        generate_commands_superclass
        generate_commands
        generate_delegates_superclass
        generate_delegates      
        generate_controller
        generate_models
        generate_model_locator 
        generate_value_objects_superclass             
        generate_value_objects
        generate_views
      end
    end
  
    def define_project_variables
      @root_package = Bluehill::Properties.get_property("#{project_name}_root_package")
      @delegate_package  = "#{@root_package}.business"
      @command_package   = "#{@root_package}.command"
      @control_package   = "#{@root_package}.control"
      @event_package     = "#{@root_package}.event"
      @model_package     = "#{@root_package}.model"
      @util_package      = "#{@root_package}.util"      
      @view_package      = "#{@root_package}.view"
      @vo_package        = "#{@root_package}.vo"

      @event_names_class    = "#{@project_name}Events"
      @commands_superclass  = "#{@project_name}Command"    
      @delegates_superclass = "#{@project_name}Delegate"        
      @controller_classname = "#{@project_name}Controller"
      @model_locator_classname = "#{@project_name}ModelLocator"
      @vo_superclass        = "#{@project_name}VO"    
            
      @event_names          = Bluehill::Properties.events_for_project(@project_name)
      @delegate_names       = Bluehill::Properties.delegates_for_project(@project_name)      
      @base_url             = Bluehill::Properties.get_property("#{@project_name}_base_url")
      @http_services_hash   = Bluehill::Properties.http_services_for_project(@project_name)
      @model_names          = Bluehill::Properties.models_for_project(@project_name)       
      @view_names           = Bluehill::Properties.views_for_project(@project_name)       
      @vo_names             = Bluehill::Properties.value_objects_for_project(@project_name)      
      @http_services_hash.keys.each { | key | 
        svc_hash = @http_services_hash[key]
        path = svc_hash['path']
        svc_hash['url'] = "#{@base_url}#{path}"
      }
      @http_services_list   = []
      @http_services_hash.keys.sort.each { | key | @http_services_list << @http_services_hash[key] }
    end  
  
    def create_project_directories
      create_dir(src_dir)
      create_dir(business_dir)
      create_dir(command_dir)
      create_dir(control_dir)
      create_dir(event_dir)    
      create_dir(model_dir)
      create_dir(util_dir)         
      create_dir(view_dir)
      create_dir(vo_dir)                        
    end
  
    def create_dir(path)
      if File.exist?(path) && File.directory?(path)
        puts "dir exists:   #{path}"
      else
        puts "creating dir: #{path}"
        FileUtils.mkdir_p(path)
      end
    end
  
    def src_dir
      "#{workspace_dir}/#{project_name}/src"
    end
  
    def business_dir
      standard_cairngorm_dir('business')
    end
  
    def command_dir
      standard_cairngorm_dir('command')
    end
  
    def control_dir
      standard_cairngorm_dir('control')
    end  
  
    def event_dir
      standard_cairngorm_dir('event')
    end
    
    def model_dir
      standard_cairngorm_dir('model')
    end

    def util_dir
      standard_cairngorm_dir('util')
    end
      
    def view_dir
      standard_cairngorm_dir('view')
    end
  
    def vo_dir
      standard_cairngorm_dir('vo')
    end 
  
    def standard_cairngorm_dir(name)
      "#{workspace_dir}/#{project_name}/src/#{root_package}/#{name}".tr('.','/')
    end
  
    def generate_services_mxml
      template_text = read_template('services_mxml')
      erb_template  = ERB.new(template_text, 0, ">")
      out_file = "#{business_dir}/Services.mxml"
      write_file(out_file, erb_template.result(binding)) if erb_template
    end

    def generate_service_result_utility
      template_text = read_template('service_result_utility')
      erb_template  = ERB.new(template_text, 0, ">")
      out_file = "#{util_dir}/ServiceResultUtil.as"
      write_file(out_file, erb_template.result(binding)) if erb_template
    end
      
    def generate_events_class
      @constant_definitions = [];
      longest = 0
      @event_names.each { | ename | longest = ename.size if ename.size > longest }
      @event_names.sort.each { | ename | # ename is a value like 'SHOW_CHART'
        format = "%-s#{longest + 4}"
        padded_ename = sprintf("%-#{longest + 2}s", ename)
        @constant_definitions << "public static const EVENT_#{padded_ename} : String = \"#{ename}\";\n"
      }
      template_text = read_template('events_class')
      erb_template  = ERB.new(template_text, 0, ">")
      out_file = "#{event_dir}/#{@event_names_class}.as"
      write_file(out_file, erb_template.result(binding)) if erb_template
    end
  
    def generate_events
      @event_names.each { | ename |
        @event_name = "EVENT_#{ename}"
        @event_subclassname = "#{ename.downcase.to_camel_case}Event"
        template_text = read_template('event_class')
        erb_template  = ERB.new(template_text, 0, ">")
        out_file = "#{event_dir}/#{@event_subclassname}.as"
        write_file(out_file, erb_template.result(binding)) if erb_template
      }
    end  
  
    def generate_commands_superclass
      template_text = read_template('command_superclass')
      erb_template  = ERB.new(template_text, 0, ">")
      out_file = "#{command_dir}/#{@commands_superclass}.as"
      write_file(out_file, erb_template.result(binding)) if erb_template
    end

    def generate_commands
      @event_names.each { | ename |
        @event_name = "EVENT_#{ename.upcase}"
        @command_subclassname = "#{ename.downcase.to_camel_case}Command"
        @event_subclassname   = "#{ename.downcase.to_camel_case}Event"
        define_command_service_variables(ename)
        define_command_delegate_variables(ename)
        template_text = read_template('command')
        erb_template  = ERB.new(template_text, 0, ">")
        out_file = "#{command_dir}/#{@command_subclassname}.as"
        write_file(out_file, erb_template.result(binding)) if erb_template
      }  
    end

    def generate_delegates_superclass
      template_text = read_template('delegate_superclass')
      erb_template  = ERB.new(template_text, 0, ">")
      out_file = "#{business_dir}/#{@delegates_superclass}.as"
      write_file(out_file, erb_template.result(binding)) if erb_template
    end

    def generate_delegates
      @delegate_names.each { | dname |
        @delegate_subclassname = "#{dname.downcase.to_camel_case}Delegate"
        define_delegate_service_variables(dname)
        template_text = read_template('delegate')
        erb_template  = ERB.new(template_text, 0, ">")
        out_file = "#{business_dir}/#{@delegate_subclassname}.as"
        write_file(out_file, erb_template.result(binding)) if erb_template
      }  
    end
        
    def define_command_service_variables(ename)
      @command_service_name, @command_service_type = '', ''
      svc_name = Bluehill::Properties.get_property("#{project_name}_command_svc_name_#{ename.downcase}")
      svc_type = Bluehill::Properties.get_property("#{project_name}_command_svc_type_#{ename.downcase}")
      if svc_name && svc_type
        @command_service_name = svc_name
        @command_service_type = svc_type
      end
    end
    
    def define_command_delegate_variables(ename)
      # YourApplication_command_get_exch_list_361_delegate = get_exch_list_361
      @command_delegate_name = ''
      dname = Bluehill::Properties.get_property("#{project_name}_command_#{ename.downcase}_delegate")
      if dname && dname.strip.size > 1
        @delegate_classname = "#{dname.strip.downcase.to_camel_case}Delegate"
      else
        @delegate_classname = nil
      end
    end
        
    def define_delegate_service_variables(name)
      @delegate_service_name, @delegate_service_type = '', ''
      svc_name = Bluehill::Properties.get_property("#{project_name}_delegate_svc_name_#{name.downcase}")
      svc_type = Bluehill::Properties.get_property("#{project_name}_delegate_svc_type_#{name.downcase}")
      if svc_name && svc_type
        @delegate_service_name = svc_name
        @delegate_service_type = svc_type
      end
    end
    
    def generate_controller
      @command_mappings = [];
      longest = 0
      @event_names.each { | ename | longest = ename.size if ename.size > longest }
      @event_names.sort.each { | ename | # ename is a value like 'SHOW_CHART'
        format = "%-s#{longest + 4}"
        padded_ename = sprintf("%-#{longest + 2}s", ename)
        @command_mappings << "addCommand( #{@event_names_class}.EVENT_#{padded_ename} , #{ename.downcase.to_camel_case}Command );\n"
      }
      template_text = read_template('controller')
      erb_template  = ERB.new(template_text, 0, ">")
      out_file = "#{control_dir}/#{@project_name}Controller.as"
      write_file(out_file, erb_template.result(binding)) if erb_template
    end
    
    def generate_models
      @model_names.each { | model_name |  
        @model_classname = model_name
        template_text = read_template('model')
        erb_template  = ERB.new(template_text, 0, ">")
        out_file = "#{model_dir}/#{@model_classname}.as"
        write_file(out_file, erb_template.result(binding)) if erb_template   
      }
    end
  
    def generate_model_locator
      template_text = read_template('model_locator')
      erb_template  = ERB.new(template_text, 0, ">")
      out_file = "#{model_dir}/#{@model_locator_classname}.as"
      write_file(out_file, erb_template.result(binding)) if erb_template
    end
  
    def generate_value_objects_superclass
      template_text = read_template('vo_superclass')
      erb_template  = ERB.new(template_text, 0, ">")
      out_file = "#{vo_dir}/#{@vo_superclass}.as"
      write_file(out_file, erb_template.result(binding)) if erb_template  
    end
    
    def generate_value_objects
      @vo_names.each { | vo_name |  
        @vo_classname = vo_name
        template_text = read_template('vo')
        erb_template  = ERB.new(template_text, 0, ">")
        out_file = "#{vo_dir}/#{vo_name}.as"
        write_file(out_file, erb_template.result(binding)) if erb_template       
      }
    end

    def generate_views
      @view_names.each { | view_info |
        tokens = view_info.split
        @view_name, @view_superclass = tokens[0].strip, tokens[1].strip    
        template_text = read_template('view')
        erb_template  = ERB.new(template_text, 0, ">")
        out_file = "#{view_dir}/#{@view_name}.mxml"
        write_file(out_file, erb_template.result(binding)) if erb_template       
      }
    end
      
    def read_template(type)
      template_filename = Bluehill::Properties.get_property("global_#{type}_template")
      if File.exist?(template_filename)
        IO.read(template_filename)
      else
        puts "#{type} template file does not exist: #{template_filename}"
        nil
      end
    end
    
  end
  
end