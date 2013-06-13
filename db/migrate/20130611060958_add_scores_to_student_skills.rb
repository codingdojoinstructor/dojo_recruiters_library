class AddScoresToStudentSkills < ActiveRecord::Migration
  def change
    add_column :student_skills, :scores, :float
  end
end
