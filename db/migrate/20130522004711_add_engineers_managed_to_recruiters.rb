class AddEngineersManagedToRecruiters < ActiveRecord::Migration
  def change
    add_column :recruiters, :engineers_managed, :integer
  end
end
