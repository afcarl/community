require "csv"

namespace :data do
   
  desc "Ad-hoc scan of the csv files"
  task :scan_csv do
    col_names = {}
    Dir.glob("data/*.csv").each_with_index do | f, i |
      lines = CSV.read(f)
      if lines.size > 0
        header = lines[0]
        puts "header: #{header} file #{i} #{f.strip} "
        header.each { | col_name | col_names[col_name] = :column }
      else
        puts "file #{i} #{f.strip} is empty"
      end
    end
    puts col_names.keys.sort.join(' ')

    # rake data:scan_csv | sort
    # - ["course_id", "course_name", "state"]  <- Courses appear to look like this
    # - ["user_id", "user_name", "state"]      <- Students appear to look like this
    # - ["course_id", "user_id", "state"]      <- Enrollments appear to look like this
    #
    # unique col names: course_id course_name state user_id user_name
  end
  
end