class AddRatingTypeToRatings < ActiveRecord::Migration
  def change
    add_column :ratings, :rating_type, :string
    add_index :ratings, :rating_type
  end
end
