class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :category
      t.string :value
      t.string :description
      t.string :icon
      t.string :tooltip
      
      t.timestamps null: false
    end
  end
end
