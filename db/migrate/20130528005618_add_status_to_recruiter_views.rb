class AddStatusToRecruiterViews < ActiveRecord::Migration
  def change
    add_column :recruiter_views, :status, :integer
  end
end
