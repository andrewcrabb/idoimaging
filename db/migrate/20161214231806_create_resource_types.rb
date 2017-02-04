class CreateResourceTypes < ActiveRecord::Migration
  def change
    create_table :resource_types do |t|
      t.string :name
      t.string :description

      t.timestamps null: false
    end
    add_index :resource_types, :name,   unique: true
  end
end
