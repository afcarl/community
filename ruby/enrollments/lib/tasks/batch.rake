require "csv_processor"

namespace :batch do
   
  desc "Process the csv data files"
  task :process_csv_data => :environment do
    Dir.glob("data/*.csv").each do | f |
      CsvProcessor.new(f).process
    end
  end
  
  desc "Produce the Students report"
  task :students_report => :environment do
    Reporter.new.produce_students_report
  end

  desc "Produce the Courses report"
  task :courses_report => :environment do
    Reporter.new.produce_courses_report
  end

  desc "Produce the Currently Active report"
  task :currently_active_report => :environment do
    Reporter.new.produce_currently_active_report
  end

end