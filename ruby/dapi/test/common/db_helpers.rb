
module DBHelpers

  def all_tables
    ActiveRecord::Base.connection.tables
  end

  def ignored_tables
    %w(sessions schema_migrations)
  end

  def display_models(name=nil)
    all_tables.each do | tbl_name |
      unless ignored_tables.include?(tbl_name)
        if (name.nil?) || (name == tbl_name)
          tbl_name.singularize.classify.constantize.all.each do | model |
            Rails.logger.debug "display_models: #{model.inspect}"
          end
        end
      end
    end
  end

  def log_table_row_counts
    ActiveRecord::Base.connection.tables.each do | tbl_name |
      result = ActiveRecord::Base.connection.execute("select count(*) from #{tbl_name};")
      message = format("row count, table: %34s  %s", tbl_name, result.first[0])
      Rails.logger.debug(message)
      puts message
    end
  end

  def truncate_tables(table_names=nil)
    start_time  = Time.now.to_f
    table_names = all_tables if table_names.nil?
    table_names.each do | tbl_name |
      unless tbl_name == 'schema_migrations'
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{tbl_name}")
      end
    end
    elapsed = Time.now.to_f - start_time
    Rails.logger.debug "truncate_tables in #{elapsed} seconds"
  end

end
