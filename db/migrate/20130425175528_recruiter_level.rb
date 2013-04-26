class RecruiterLevel < ActiveRecord::Migration
  def up
  	add_column :recruiters, :level, :integer
  end

  def down
  	remove_column :recruiters, :level
  end
end
