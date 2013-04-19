class CreateStudentBelts < ActiveRecord::Migration
  def change
    create_table :student_belts do |t|
      t.datetime :earned_at
      t.references :belt
      t.references :student

      t.timestamps
    end
    add_index :student_belts, :belt_id
    add_index :student_belts, :student_id
  end
end
