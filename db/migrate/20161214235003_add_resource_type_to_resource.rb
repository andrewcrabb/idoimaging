class AddResourceTypeToResource < ActiveRecord::Migration
  def change
    add_reference :resources, :resource_type, index: true, foreign_key: true
  end
end
