class CreateRecruiterViews < ActiveRecord::Migration
  def change
    create_table :recruiter_views do |t|
      t.references :recruiter
      t.references :student

      t.timestamps
    end
    add_index :recruiter_views, :recruiter_id
    add_index :recruiter_views, :student_id
  end
end
