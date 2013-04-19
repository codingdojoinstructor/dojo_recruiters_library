class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.string :email
      t.string :encrypted_password
      t.integer :level
      t.string :location
      t.string :salt
      
      t.datetime :hired_date
      t.string :hired_company

      t.timestamps
    end
  end
end
