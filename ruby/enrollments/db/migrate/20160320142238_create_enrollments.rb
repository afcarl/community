class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.string :course_id
      t.string :student_id
      t.string :state

      t.timestamps null: false
    end

    add_index(:enrollments, [:course_id, :student_id], unique: true, name: 'unique_enrollments')
  end
end
