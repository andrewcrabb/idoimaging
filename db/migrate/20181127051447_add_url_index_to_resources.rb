class AddUrlIndexToResources < ActiveRecord::Migration[5.2]
  def change
    add_index :resources, :url
  end
end
