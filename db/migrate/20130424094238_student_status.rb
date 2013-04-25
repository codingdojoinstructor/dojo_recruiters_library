class StudentStatus < ActiveRecord::Migration
  def up
  	add_column :students, :status, :integer
  end

  def down
  	remove_column :students, :status
  end
end
