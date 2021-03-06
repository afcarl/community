=begin

Bluehill = Flex/ActionScript code generation focusing on the Cairngorm framework.
Copyright 2010 by Chris Joakim.
Bluehill is available under GNU General Public License (GPL) license.

=end

module Bluehill
  
  module InputOutput
                
    def read_file_as_lines(filename)
      IO.readlines(filename)
    end
  
    def write_lines(out_name, lines)
      s = ''
      lines.each { | line | 
        s << line
        s << "\n"
      }
      write_file(out_name, s)
    end

    def write_file(out_name, content, mode='w+')
      if File.exist?(out_name)
        if Bluehill::Properties.overwrite?
          if has_overwrite_marker?(out_name)
            if Bluehill::Properties.create_backup_files?
              FileUtils.cp(out_name, "#{out_name}.bak")
            end
            return write(out_name, content, 'overwritten')
          else
          puts "file not overwritten: #{out_name} due to removal of OVERWRITE marker"
          end
        else
          puts "file not overwritten: #{out_name} per Overwrite files configuration"
          return false
        end
      else
        return write(out_name, content, 'written')
      end
    end
              
    def reset_generation_counts
      @@files_generated, @@lines_generated = 0, 0
    end

    def display_generation_counts
      puts "#{@@files_generated} files generated, #{@@lines_generated} lines of code."
    end
         
    private
    
    def write(out_name, content, word, mode='w+')
      out = File.new out_name, mode
      out.write content
      out.flush
      out.close
      puts "file #{word}: #{out_name}"
      @@files_generated = @@files_generated + 1
      sio = StringIO.new(content)
      @@lines_generated = @@lines_generated + sio.readlines.size
      true
    end
    
    def has_overwrite_marker?(out_name)
      read_file_as_lines(out_name).each { | line |
        if line.index('Generated by Bluehill')
          if line.index('NO_OVERWRITE')
            return false
          elsif line.index('NOOVERWRITE')
            return false
          elsif line.index('OVERWRITE')
            return true
          end
        end
      }
      false
    end
    
  end
  
end