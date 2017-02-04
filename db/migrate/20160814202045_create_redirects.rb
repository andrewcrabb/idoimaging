class CreateRedirects < ActiveRecord::Migration
  def change
    create_table :redirects do |t|
      t.date :date
      t.references :resource, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
