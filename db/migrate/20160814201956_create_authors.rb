class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name_last
      t.string :name_first
      t.string :institution
      t.string :email
      t.string :country

      t.timestamps null: false
    end
  end
end
