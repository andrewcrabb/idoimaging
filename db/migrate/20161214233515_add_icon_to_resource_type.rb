class AddIconToResourceType < ActiveRecord::Migration
  def change
    add_column :resource_types, :icon, :string
  end
end
