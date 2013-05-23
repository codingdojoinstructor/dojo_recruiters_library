class AddTermsAndConditionToRecruiters < ActiveRecord::Migration
  def change
    add_column :recruiters, :terms_and_condition, :text
  end
end
