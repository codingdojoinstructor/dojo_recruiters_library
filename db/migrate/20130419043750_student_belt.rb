class StudentBelt < ActiveRecord::Migration
  def up
  	add_column :student_belts, :score, :float
  	add_index :student_belts, [:belt_id, :student_id], :unique => true
  end

  def down
  	remove_column :student_belts, :score
  	remove_index :student_belts, [:belt_id, :student_id]
  end
end
