class AddKindToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :kind, :integer, default: 0
    add_index :programs, :kind
  end
end
