class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.string :name
      t.string :summary
      t.text :description
      t.date :add_date
      t.date :remove_date

      t.timestamps null: false
    end
  end
end
