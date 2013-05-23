class AddTermsStatusToRecruiters < ActiveRecord::Migration
  def change
    add_column :recruiters, :terms_status, :integer
  end
end
