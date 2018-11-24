class AddIconPrefixToResourceType < ActiveRecord::Migration[5.2]
  def change
    add_column :resource_types, :icon_prefix, :string
  end
end
