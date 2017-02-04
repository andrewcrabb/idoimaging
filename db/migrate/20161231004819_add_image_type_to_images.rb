class AddImageTypeToImages < ActiveRecord::Migration
  def change
    add_column :images, :image_type, :string
    add_index :images, :image_type
  end
end
