class CreateRecruiterCandidates < ActiveRecord::Migration
  def change
    create_table :recruiter_candidates do |t|
      t.references :recruiter
      t.references :student

      t.timestamps
    end
    add_index :recruiter_candidates, :recruiter_id
    add_index :recruiter_candidates, :student_id
  end
end
