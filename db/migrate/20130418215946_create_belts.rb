class CreateBelts < ActiveRecord::Migration
  def change
    create_table :belts do |t|
      t.string :name

      t.timestamps
    end
  end
end
