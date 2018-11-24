class AddIconPrefixToFeatures < ActiveRecord::Migration[5.2]
  def change
    add_column :features, :icon_prefix, :string
  end
end
