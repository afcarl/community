=begin

Bluehill = Flex/ActionScript code generation focusing on the Cairngorm framework.
Copyright 2010 by Chris Joakim.
Bluehill is available under GNU General Public License (GPL) license.

=end
    
module Bluehill
  
  class Properties

    @@hash, @@array = Hash.new(''), []
  
    def self.add(key, value)
      # puts "Bluehill::Properties.add #{key} #{value}"
      if key && value
        @@hash[key.strip] = value.strip     # add or overlay the key in the Hash
        @@array << [key.strip, value.strip] # and also append to the Array
      end
    end
    
    def self.hash_values
      @@hash
    end
  
    def self.array_values
      @@array
    end

    # Return a simple scalar value for the given name.
    def self.get_property(name, default='')
      if name
        if @@hash.has_key? name
          return @@hash[name]
        end
      end
      # puts "Properties.get_property defaulting to '#{default}' for '#{name}'" if verbose?
      default
    end

    def self.verbose?
      get_boolean_property('global_verbose')
    end
 
    def self.overwrite?
      get_boolean_property('global_overwrite')
    end

    def self.create_backup_files?
      get_boolean_property('global_backup_files')
    end
          
    def self.get_boolean_property(name, default=false)
      if name
        if @@hash.has_key? name
          val = @@hash[name].downcase
          return true  if val == 'true'
          return true  if val == 't'
          return true  if val == 'yes'
          return true  if val == 'y'
          return false                                    
        end
      end
      default
    end
  
    # Return an Array.  The given name may be non-unique in the properties file,
    # so that multiple entries may be returned.
    def self.get_array_property(name, default=[])
      a = []
      if name
        @@array.each { | elem | a << elem[1] if (elem[0] == name) }
      end
      a
    end
  
    def self.unique_values(list)
      hash, new_list = {}, []
      if list
        list.each { | item | hash[item] = item }
      end
      hash.keys.each { | key | new_list << key }
      new_list
    end  
  
    def self.project_list
      get_array_property('project', default=[])
    end
  
    def self.events_for_project(project)
      unique_values(get_array_property("#{project}_event", default=[]))
    end

    def self.delegates_for_project(project)
      unique_values(get_array_property("#{project}_delegate", default=[]))
    end
    
    def self.http_services_for_project(project)
      hash_of_service_hashes = {}
      project_key_prefix = "#{project}_http_svc"
      svc_name_list = get_array_property(project_key_prefix, default=[])
      svc_name_list.each { | svc_name |
        service_key_prefix = "#{project_key_prefix}_#{svc_name}"
        # puts "service_key_prefix: #{service_key_prefix}"
        svc_hash = {}
        svc_hash['name']   = svc_name
        svc_hash['method'] = @@hash["#{project}_http_svc_#{svc_name} method"]
        svc_hash['path']   = @@hash["#{project}_http_svc_#{svc_name} path"]
        svc_hash['format'] = @@hash["#{project}_http_svc_#{svc_name} format"]
        hash_of_service_hashes[svc_name] = svc_hash        
      }
      hash_of_service_hashes
    end
    
    def self.models_for_project(project)
      get_array_property("#{project}_model", default=[])
    end
    
    def self.value_objects_for_project(project) 
      get_array_property("#{project}_vo", default=[])
    end
    
    def self.views_for_project(project)
      get_array_property("#{project}_view", default=[])
    end    
    
  end

end
