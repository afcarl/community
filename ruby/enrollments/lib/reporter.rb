require "csv"

class Reporter

  def produce_students_report()
    puts "\nStudents, active:"
    Student.all.active.order(:id).each do | s |
      puts "  #{s.id} #{s.name}"
    end
    puts "\nStudents, inactive:"    
    Student.all.inactive.order(:id).each do | s |
      puts "  #{s.id} #{s.name}"
    end
    puts ""
  end

  def produce_courses_report
    puts "\nCourses, active:"
    Course.all.active.order(:id).each do | c |
      puts "  #{c.id} #{c.name}"
    end
    puts "\nCourses, inactive:"    
    Course.all.inactive.order(:id).each do | c |
      puts "  #{c.id} #{c.name}"
    end
    puts ""
  end

  def produce_currently_active_report
    puts "\nCurrently Active Report\n"
    Course.all.active.order(:id).each do | c |
      printf "\nCourse - number: %-10s  name: %s\n", c.id, c.name
      enrollments = c.enrollments
      enrollments.each do | e |
        if e.active?
          s = e.student
          if s && s.active?
            printf "  %-10s %s\n", s.student_id, s.name
          end
        end
      end
    end
  end

end
