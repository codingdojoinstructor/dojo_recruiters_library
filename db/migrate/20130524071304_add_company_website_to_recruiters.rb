class AddCompanyWebsiteToRecruiters < ActiveRecord::Migration
  def change
    add_column :recruiters, :company_website, :string
  end
end
