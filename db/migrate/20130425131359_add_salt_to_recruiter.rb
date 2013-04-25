class AddSaltToRecruiter < ActiveRecord::Migration
  def change
  	add_column :recruiters, :salt, :string
  end
end
