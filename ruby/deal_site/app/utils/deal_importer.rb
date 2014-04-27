require 'csv'

# The function of this class is to process csv data "deal" files provided by our
# publisher clients.  This class is invoked from rake tasks; see 'deals.rake'.
#
# We specify our "standard/default" csv file format to the publishers, and they
# should provide us csv data per that standard.  Our logic does allow, however,
# for an alternative csv file format to be specified and used.  For example, the
# merchant name may be in the 4th field rather than the first.  The formats are
# defined in *.json files in the config/ directory, and are optionally specified
# in the rake task command-line arguments.
#
# We ignore the actual header values in the csv files provided by the publishers,
# as these values may vary.
#
# This logic examines each CSV row for validity, per the specified csv format.
# Invalid rows are not processed/persisted by this Importer.

class DealImporter

  attr_reader :options, :publisher_id, :csv_data_filename, :csv_format_filename, :csv_file_fields
  attr_reader :field_seq_map, :field_name_map, :field_type_map, :advertiser_name_map
  attr_reader :fatal_error, :valid_row_count, :invalid_row_count
  attr_reader :advertisers_created, :deals_created

  def initialize(opts={})
    @options = opts
    @publisher_id        = opts[:publisher_id].to_i
    @csv_data_filename   = opts[:csv_data_filename]
    @csv_format_filename = opts[:csv_format_filename]
    @csv_format_filename = default_csv_format_filename if csv_format_filename.nil?
    @fatal_error, @valid_row_count, @invalid_row_count = nil, 0, 0
    @advertisers_created, @deals_created = 0, 0
    @field_seq_map, @field_name_map, @field_type_map, @advertiser_name_map = {}, {}, {}, {}

    log("initialize, options:  #{options.inspect}", true)
    lookup_publisher
    validate_csv_format_file unless fatal_error
    validate_csv_data_file   unless fatal_error

    unless fatal_error
      @csv_file_fields = JSON.parse(IO.read(csv_format_filename))
      csv_file_fields.each_with_index do | field_hash, idx |
        index, name, type = field_hash['index'].to_i, field_hash['name'], field_hash['type']
        @field_seq_map[index] = name
        @field_name_map[name] = index
        @field_type_map[name] = type
      end
      Advertiser.all.each { | a | @advertiser_name_map[a.name] = a.id }
    end
  end

  def process_deals(persist=false)
    log("process_deals, persist:  #{persist}", true)
    unless @fatal_error
      row_number = 0
      CSV.foreach(csv_data_filename, :headers => true) do | row |
        row_number = row_number + 1
        if row_valid?(row, row_number)
          @valid_row_count = valid_row_count + 1
          merch = handle_merchant(row, persist)
          create_deal(row, merch) if persist
        else
          @invalid_row_count = invalid_row_count + 1
          log("row number #{row_number} is invalid: #{row.inspect}")
        end
      end
      log("processing completed", true)
    end
  end

  def eoj_report
    log("eoj_report", true)
    log("  fatal_error?         #{fatal_error != nil}", true)
    log("  valid_row_count:     #{valid_row_count}", true)
    log("  invalid_row_count:   #{invalid_row_count}", true)
    log("  advertisers_created: #{advertisers_created}", true)
    log("  deals_created:       #{deals_created}", true)
  end

  private

  def lookup_publisher
    begin
      p = Publisher.find(publisher_id)
    rescue Exception => e
      handle_fatal_error("publisher_id does not exist: #{publisher_id}")
    end
  end

  def default_csv_format_filename
    'config/csv_file_format.json'
  end

  def validate_csv_format_file
    unless File.exist? csv_format_filename.to_s
      handle_fatal_error("csv_format_filename does not exist: #{csv_format_filename}")
    end
  end

  def validate_csv_data_file
    unless File.exist? csv_data_filename.to_s
      handle_fatal_error("csv_data_filename does not exist: #{csv_data_filename}")
    end
  end

  def row_valid?(row, row_number)
    return false if row.nil? || (row.size != @field_seq_map.size)
    validate_row_values(row, row_number)
  end

  def validate_row_values(row, row_number)
    errors = []
    row.each_with_index do | col, idx |  # col -> ["Merchant", "Burger King"]
      field_name = field_seq_map[idx]
      field_type = field_type_map[field_name]

      case field_type
      when 'date'
        begin
          Date.strptime(col[1], "%m/%d/%Y")
        rescue Exception => e
          errors << "field '#{field_name}' (#{field_type}) of row #{row_number} is invalid; <<#{col[1]}>>"
        end
      when 'int'
        if col[1].nil? || col[1].to_i < 1
          errors << "field '#{field_name}' (#{field_type}) of row #{row_number} is invalid; <<#{col[1]}>>"
        end
      else
        if col[1].nil? || col[1].strip.size < 1
          errors << "field '#{field_name}' (#{field_type}) of row #{row_number} is invalid; <<#{col[1]}>>"
        end
      end
    end
    if errors.empty?
      true
    else
      errors.each { | err | log(err, true) }
      false
    end
  end

  def field_value(name, row)
    row[field_name_map[name]]
  end

  def merchant_name(row)
    field_value('merchant', row)
  end

  def handle_merchant(row, persist)
    merch = merchant_name(row)
    unless @advertiser_name_map.has_key?(merch)
      log("new merchant encountered: #{merch}", true)
      if persist
        a = Advertiser.create(:publisher_id => publisher_id, :name => merch)
        @advertisers_created = advertisers_created + 1
        @advertiser_name_map[merch] = a.id
      else
        @advertiser_name_map[merch] = 0
      end
    end
    merch
  end

  def create_deal(row, merch)
    begin
      d = Deal.new
      d.proposition   = field_value('deal', row)
      d.price         = field_value('price', row)
      d.value         = field_value('value', row)
      d.advertiser_id = @advertiser_name_map[merch]
      d.description   = field_value('deal', row)
      d.start_at      = field_value('start_date', row)
      d.end_at        = field_value('end_date', row)
      d.save!
      @deals_created = deals_created + 1
    rescue Exception => e
      log_exception(row, e)
    end
  end

  def handle_fatal_error(msg)
    @fatal_error = msg
    log("FATAL ERROR - #{msg}", true)
  end

  def log(message, write_to_console=false)
    msg = "DealImporter - #{message}"
    Rails.logger.error(msg)
    if write_to_console
      unless silent?  # tests specify silent mode
        puts msg      # this is the one 'puts' in this class
      end
    end
  end

  def log_exception(row, e)
    log("EXCEPTION - #{e.class.name} #{e.message} on row #{row.inspect}", true)
  end

  def silent?
    true == options[:silent]
  end

end
