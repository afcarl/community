
def gooby_home
  ENV['GOOBY_HOME']
end

def directory?(word)
  return false if word.nil?
  return true  if word.downcase == 'directory'
  return true  if word.downcase == 'dir'
  return true  if word.downcase == 'folder'
  false  
end

Then /^GOOBY_HOME is set to '(.*)'$/ do | dir_name |
  ENV['GOOBY_HOME'] = dir_name
  `env > tmp/cuke_env.txt`
  gooby_home.should == dir_name
end

Then /^the config file we use is '(.*)'$/ do | file |
  @config_file = file
end

Then /^we imported the data from our Garmin GPS device model 305 into Garmin Training Center$/ do
 # This step is for documentation purposes only
end

Then /^exported the data from Garmin Training Center to a TCX file$/ do
 # This step is for documentation purposes only
end

Then /^the TCX file is named '(.*)'$/ do | filename |
  @tcx_filename = filename
end

Then /^an empty (.*) directory within GOOBY_HOME$/ do | dir |
  pattern = "#{gooby_home}/#{dir}/*.*"
  FileUtils.rm Dir.glob(pattern)
  Dir.glob(pattern).size.should == 0 
end

Then /^file '(.*)' does not exist within GOOBY_HOME$/ do | file |
  full_name = "#{gooby_home}/#{file}"  
  if File.exist?(full_name)
    FileUtils.rm(full_name)
  end
  File.exist?(full_name).should == false
end

Then /^rake task '(.*)' is executed$/ do | task_name |
  @gooby_task    = task_name.split(':')[1]
  @redirect_file = "tmp/#{@gooby_task}.txt"  
  params = ''
  if task_name == 'gooby:extract_activities_from_tcx'
    params = "tcx_file=#{@tcx_filename}"
  end
  if @config_file
    params << "config_file=#{@config_file}"
  end
  command = "rake #{task_name} #{params} > #{@redirect_file}"
  `#{command}`
end

Then /^the (.*) file '(.*)' is created$/ do | type, file |
  File.exists?(file).should == true
  lines = IO.readlines(file)
  if type == 'CSV'
    @csv_filename, @csv_lines = file, lines
  elsif type == 'HTML'
    @html_filename, @html_lines = file, lines
  elsif type == 'KML'
    @kml_filename, @kml_lines = file, lines
  elsif type == 'KMZ'
    @kmz_filename = file
  end
end

Then /^the following lines are expected$/ do
  @expected_lines = []
end

Then "line: $to_eol" do | to_eol |
  @expected_lines << to_eol.strip
end

Then /^the CSV file contains (.*) trackpoints$/ do | count |
  trackpoints = []
  FasterCSV.foreach(@csv_filename) do | row |
    tkpt = GoobyTrackpoint.new
    tkpt.from_csv(row)
    trackpoints << tkpt
  end
  trackpoints.size.should == count.to_i
end

Then /^the HTML file contains (.*) lines$/ do | count |
  @html_lines.size.should == count.to_i
end

Then /^the KML file contains (.*) lines$/ do | count |
  @kml_lines.size.should == count.to_i
end

Then /^the splits directory contains at least (.*) files matching name '(.*)'$/ do | count, p |
  pattern = "#{gooby_home}/splits/#{p}*"
  list = Dir.glob(pattern)
  list.size.should >= count.to_i
end

Then /^these activity xml files exist:$/ do | table |
  table.hashes.each do | hash |
    lines = IO.readlines(hash['file'])
    lines.size.should == hash['lines'].to_i
  end
end

Then /^the output contains (.*) lines, within a tolerance of (.*)$/ do | count, tolerance |
  @redirect_file_lines = IO.readlines(@redirect_file)
  @redirect_file_lines.size.should >= count.to_i - tolerance.to_i
  @redirect_file_lines.size.should <= count.to_i + tolerance.to_i  
end

Then /^the (.*) contains the expected lines$/ do | type |
  content_lines = @csv_lines  if type == 'CSV'
  content_lines = @html_lines if type == 'HTML'
  content_lines = @kml_lines  if type == 'KML'
  content_lines = @redirect_file_lines  if type == 'output'  
  prev_match_idx = -1
  @expected_lines.each { | expected_line |
    matched = false
    content_lines.each_with_index { | content_line, content_line_idx | 
      if content_line_idx > prev_match_idx
        pos_idx = content_line.strip.index(expected_line)
        if (pos_idx) && (pos_idx >= 0)
          matched, prev_match_idx = true, content_line_idx
        end
      end
    }
    matched.should == true
  }
end

Then /^we edit CSV file '(.*)' to contain only point number (.*)$/ do | file, point_number |
  lines = IO.readlines(file)
  out = File.new file, 'w+'
  out.write lines[point_number.to_i]
  out.flush
  out.close
end

Then /^the CSV file contains these trackpoints:$/ do | table |
  trackpoints = []
  FasterCSV.foreach(@csv_filename) do | row |
    tkpt = GoobyTrackpoint.new
    tkpt.from_csv(row)
    trackpoints << tkpt
  end
  table.hashes.each do | hash |
    seq = hash['seq'].to_i
    seq.should > 0
    seq.should <= trackpoints.size
    tkpt = trackpoints[seq - 1]
    tkpt.latitude.to_s.should     == hash['latitude']
    tkpt.longitude.to_s.should    == hash['longitude']
    tkpt.distance.to_s.should     == hash['distance']        
    tkpt.elapsed_time.to_s.should == hash['elapsed']    
    tkpt.mph.to_s.should          == hash['mph']
    tkpt.pace.to_s.should         == hash['pace']            
  end
end

Then /^copy the generated files to the samples directory$/ do
  list = []
  list << 'csv/2008_04_27_13_49_50_tcx.csv'
  list << 'csv/ballantyne.csv'
  list << 'csv/crowders_mtn_hike.csv'
  list << 'csv/davidson1.csv'  
  list << 'out/ballantyne.kml'
  list << 'out/big_sur_marathon.html'
  list << 'out/big_sur_marathon.kml'
  list << 'out/crowders_mtn_hike.html'
  list << 'out/davidson1.html'
  list << 'out/doc.kml'
  FileUtils.cp list, "samples"
end

Then /^(.*) '(.*)' exists$/ do | word , name |
  if directory?(word)
    if File.exist?(name) && File.directory?(name)
      # ok, the directory exists
    else
      FileUtils.mkdir_p(name) 
    end
  end
  File.exist?(name).should == true
end

Then /^the GOOBY_HOME directory is recreated$/ do
  if File.exist?(gooby_home) && File.directory?(gooby_home)
    FileUtils.rm_rf(gooby_home)  
  end
  FileUtils.mkdir_p(gooby_home)     
end

Then /^my garmin training center export file 'current.tcx' file is restored$/ do
  FileUtils.cp '/data/gooby/garmin/current.tcx', "#{gooby_home}/data/current.tcx"
end
  
Then /^the gem we are (.*) is named '(.*)'$/ do | word, name |
  @gem_name = name
end

Then /^(.*) '(.*)' is removed if present$/ do | word , name |
  if (word.downcase == 'directory') || (word.downcase == 'dir')
    if File.exist?(name) && File.directory?(name)
      FileUtils.rm_rf(name) 
    end
  else
    if File.exist?(name)
      FileUtils.rm(name) 
    end    
  end
  File.exist?(name).should == false 
end

Then /^we execute the shell script '(.*)'$/ do | name |
  @shell_script_name = name
  result = `#{@shell_script_name}`
end

Then /^these (.*) files exist within directory '(.*)':$/ do | word, dir, table |
  table.hashes.each do | hash |
    filename, type = "#{dir}/#{hash['file']}".strip, hash['type'].to_s.strip
    # puts "verifying: #{dir} #{type} #{filename}"
    if directory?(type)
      File.exist?(filename).should     == true 
      File.directory?(filename).should == true
    else
      File.exist?(filename).should     == true 
      File.directory?(filename).should == false
      IO.readlines(filename).size.should > 0
    end
  end
end

