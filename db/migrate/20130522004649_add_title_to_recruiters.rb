class AddTitleToRecruiters < ActiveRecord::Migration
  def change
    add_column :recruiters, :title, :string
  end
end
