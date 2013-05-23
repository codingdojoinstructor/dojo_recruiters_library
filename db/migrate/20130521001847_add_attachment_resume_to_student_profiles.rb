class AddAttachmentResumeToStudentProfiles < ActiveRecord::Migration
  def self.up
    change_table :student_profiles do |t|
      t.attachment :resume
    end
  end

  def self.down
    drop_attached_file :student_profiles, :resume
  end
end
