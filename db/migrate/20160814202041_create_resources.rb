class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :resource_type
      t.string :url
      t.string :description
      t.date :last_seen
      t.date :last_tested
      t.string :identifier
      t.references :resourceful, polymorphic: true, index: true

      t.timestamps null: false
    end

    # add_index :resources, [:resourceful_type, :resourceful_id]

  end
end
