class AddSearchLevelToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :search_level, :string
    add_index :features, :search_level
  end
end
