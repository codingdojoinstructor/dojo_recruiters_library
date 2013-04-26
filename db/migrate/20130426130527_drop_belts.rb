class DropBelts < ActiveRecord::Migration
  def up
  	drop_table :student_belts
  	drop_table :belts

  	add_column :student_profiles, :white_belt_score, :float
  	add_column :student_profiles, :yellow_belt_score, :float
  	add_column :student_profiles, :green_belt_score, :float
  	add_column :student_profiles, :red_belt_score, :float
  	add_column :student_profiles, :black_belt_score, :float

	add_column :student_profiles, :white_belt_date, :date
  	add_column :student_profiles, :yellow_belt_date, :date
  	add_column :student_profiles, :green_belt_date, :date
  	add_column :student_profiles, :red_belt_date, :date
  	add_column :student_profiles, :black_belt_date, :date

  end

  def down
  	create_table :belts do |t|
      t.string :name

      t.timestamps
  	end

  	create_table :student_belts do |t|
      t.datetime :earned_at
      t.references :belt
      t.references :student

      t.timestamps
    end

    add_index :student_belts, :belt_id
    add_index :student_belts, :student_id
  	add_column :student_belts, :score, :float
  	add_index :student_belts, [:belt_id, :student_id], :unique => true

	remove_column :student_profiles, :white_belt_score, :float
  	remove_column :student_profiles, :yellow_belt_score, :float
  	remove_column :student_profiles, :green_belt_score, :float
  	remove_column :student_profiles, :red_belt_score, :float
  	remove_column :student_profiles, :black_belt_score, :float

	remove_column :student_profiles, :white_belt_date, :date
  	remove_column :student_profiles, :yellow_belt_date, :date
  	remove_column :student_profiles, :green_belt_date, :date
  	remove_column :student_profiles, :red_belt_date, :date
  	remove_column :student_profiles, :black_belt_date, :date
  end
end
