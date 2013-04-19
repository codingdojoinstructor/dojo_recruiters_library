class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :recruiter
      t.references :student

      t.timestamps
    end
    add_index :favorites, :recruiter_id
    add_index :favorites, :student_id
  end
end
