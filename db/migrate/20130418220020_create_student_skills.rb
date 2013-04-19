class CreateStudentSkills < ActiveRecord::Migration
  def change
    create_table :student_skills do |t|
      t.datetime :earned_at
      t.references :skill
      t.references :student

      t.timestamps
    end
    add_index :student_skills, :skill_id
    add_index :student_skills, :student_id
  end
end
