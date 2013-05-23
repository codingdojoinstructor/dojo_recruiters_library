class AddAttachmentAvatarUrlToStudentProfiles < ActiveRecord::Migration
  def self.up
    change_table :student_profiles do |t|
      t.attachment :avatar_url
    end
  end

  def self.down
    drop_attached_file :student_profiles, :avatar_url
  end
end
