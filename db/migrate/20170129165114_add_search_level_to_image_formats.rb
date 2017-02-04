class AddSearchLevelToImageFormats < ActiveRecord::Migration
  def change
    add_column :image_formats, :search_level, :string
    add_index :image_formats, :search_level
  end
end
