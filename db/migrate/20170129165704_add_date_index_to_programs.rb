class AddDateIndexToPrograms < ActiveRecord::Migration
  def change
    add_index :programs, :add_date
    add_index :programs, :remove_date
  end
end
