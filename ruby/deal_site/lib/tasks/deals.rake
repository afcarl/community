
# rake deals:scan_deals csv_data_filename=script/data/daily_planet_export.csv publisher_id=3
# rake deals:import_deals csv_data_filename=script/data/daily_planet_export.csv publisher_id=3

namespace :deals do

  def options
    opts = {}
    opts[:csv_data_filename]   = ENV['csv_data_filename']
    opts[:csv_format_filename] = ENV['csv_format_filename']
    opts[:publisher_id]        = ENV['publisher_id']
    opts
  end

  desc 'Scan Deals from the given csv_file arg'
  task :scan_deals => :environment do
    di = DealImporter.new(options)
    di.process_deals(false)
    di.eoj_report
  end

  desc 'Import Deals from the given csv_file arg'
  task :import_deals => :environment do
    di = DealImporter.new(options)
    di.process_deals(true)
    di.eoj_report
  end

  desc 'Generate the standard csv_file_format.json config file.'
  task :gen_config_file => :environment do
    format = [
      {:index => 0, :name => 'merchant',   :type => 'text'},
      {:index => 1, :name => 'start_date', :type => 'date'},
      {:index => 2, :name => 'end_date',   :type => 'date'},
      {:index => 3, :name => 'deal',  :type => 'text'},
      {:index => 4, :name => 'price', :type => 'int'},
      {:index => 5, :name => 'value', :type => 'int'}
    ]
    filename = 'config/csv_file_format.json'
    out = File.new filename, "w+"
    out.write JSON.pretty_generate(format)
    out.flush
    out.close
    puts "file written: #{filename}"
  end

end
