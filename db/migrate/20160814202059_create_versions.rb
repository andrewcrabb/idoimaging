class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string :version
      t.date :date
      t.string :note
      t.string :rev_str
      t.references :program, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
