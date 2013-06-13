class AddBeltIdToStudentSkills < ActiveRecord::Migration
  def change
    add_column :student_skills, :belt_id, :integer
  end
end
