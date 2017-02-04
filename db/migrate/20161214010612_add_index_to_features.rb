class AddIndexToFeatures < ActiveRecord::Migration
  def change
    add_index :features, :category
    add_index :features, :value
    add_index(:features, [:category, :value], unique: true)
  end
end
