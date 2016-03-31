require "csv"

class CsvProcessor

  attr_accessor :filename, :headers, :type
    
  def initialize(f)
    @filename, @headers, @type = f.to_s.strip, nil, :unknown
  end

  def process()
    begin
      CSV.read(@filename).each_with_index do | col_data, idx |
        if idx < 1
          @headers = col_data
          identify_type
        else
          if type != :unknown
            persist_row(col_data)
          end
        end
      end
    rescue Exception => e
      puts "CsvProcessor exception on file #{@filename}: #{e}"
    end
  end

  def identify_type
    shape = @headers.to_s.downcase
    case shape
    when '["course_id", "course_name", "state"]'
      @type = :course
    when '["user_id", "user_name", "state"]'
      @type = :student
    when '["course_id", "user_id", "state"]'
      @type = :enrollment
    end
  end

  def persist_row(col_data)
    begin
      case @type
      when :course
        persist_course(col_data)
      when :student
        persist_student(col_data)
      when :enrollment
        persist_enrollment(col_data)
      end
    rescue Exception => e
      puts "CsvProcessor exception in persist_row on #{@filename} #{col_data}: #{e}"
    end
  end

  def persist_course(col_data)
    if col_data.nil? or col_data.size < 3
      puts "persist_course; row ignored: #{col_data}"
    else
      course_id = normalize(col_data[0], true)
      name      = normalize(col_data[1])
      state     = normalize(col_data[2], true)

      model = Course.find_by_course_id(course_id)
      if model
        model.name  = name
        model.state = state
      else
        model = Course.new
        model.course_id = course_id
        model.name      = name
        model.state     = state
      end
      if model.valid?
        model.save!
      end 
    end
  end

  def persist_student(col_data)
    if col_data.nil? or col_data.size < 3
      puts "persist_student; row ignored: #{col_data}"
    else
      student_id = normalize(col_data[0], true)
      name       = normalize(col_data[1])
      state      = normalize(col_data[2], true)

      model = Student.find_by_student_id(student_id)
      if model
        model.name  = name
        model.state = state
      else
        model = Student.new
        model.student_id = student_id
        model.name       = name
        model.state      = state
      end
      if model.valid?
        model.save!
      end 
    end
  end

  def persist_enrollment(col_data)
    if col_data.nil? or col_data.size < 3
      puts "persist_enrollment; row ignored: #{col_data}"
    else
      course_id  = normalize(col_data[0], true)
      student_id = normalize(col_data[1], true)
      state      = normalize(col_data[2], true)

      model = Enrollment.find_by_course_id_and_student_id(course_id, student_id)
      if model
        model.state = state
      else
        model = Enrollment.new
        model.course_id  = course_id
        model.student_id = student_id
        model.state      = state
      end
      if model.valid?
        model.save!
      end 
    end
  end

  def normalize(value, downcase=false)
    if downcase
      value.to_s.strip.downcase
    else
      value.to_s.strip
    end
  end

  def to_s
    "file: #{filename} type: #{@type}"
  end

end
