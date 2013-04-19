class CreateStudentProfiles < ActiveRecord::Migration
  def change
    create_table :student_profiles do |t|
      t.string :image_src
      t.string :video_url
      t.string :project1_name
      t.string :project1_url
      t.string :project2_name
      t.string :project2_url
      t.string :project3_name
      t.string :project3_url
      t.string :resume_url
      t.references :student

      t.timestamps
    end
    add_index :student_profiles, :student_id
  end
end
