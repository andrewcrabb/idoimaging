class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.text :image
      t.references :imageable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
