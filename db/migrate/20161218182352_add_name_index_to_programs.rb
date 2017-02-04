class AddNameIndexToPrograms < ActiveRecord::Migration
  def change
    add_index :programs, :name
  end
end
