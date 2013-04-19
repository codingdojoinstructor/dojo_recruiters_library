class CreateRecruiters < ActiveRecord::Migration
  def change
    create_table :recruiters do |t|
      t.string :email
      t.string :encrypted_password
      t.string :name
      t.text :individual_description
      t.string :company
      t.text :company_description

      t.timestamps
    end
  end
end
