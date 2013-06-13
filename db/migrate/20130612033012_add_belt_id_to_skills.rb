class AddBeltIdToSkills < ActiveRecord::Migration
  def change
    add_column :skills, :belt_id, :integer
  end
end
