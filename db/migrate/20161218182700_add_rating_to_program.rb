class AddRatingToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :rating, :float
    add_index :programs, :rating
  end
end
