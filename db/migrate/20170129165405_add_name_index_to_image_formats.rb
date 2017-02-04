class AddNameIndexToImageFormats < ActiveRecord::Migration
  def change
    add_index :image_formats, :name
  end
end
