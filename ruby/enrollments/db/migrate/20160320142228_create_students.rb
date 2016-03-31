class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :student_id
      t.string :name
      t.string :state

      t.timestamps null: false
    end

    add_index :students, :student_id
  end
end
