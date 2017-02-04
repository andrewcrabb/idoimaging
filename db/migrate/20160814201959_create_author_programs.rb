class CreateAuthorPrograms < ActiveRecord::Migration
  def change
    create_table :author_programs do |t|
      t.references :author, index: true, foreign_key: true
      t.references :program, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
