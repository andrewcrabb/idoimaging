class CreateReadProgramImageFormats < ActiveRecord::Migration
  def change
    create_table :read_program_image_formats do |t|
      t.integer :weight
      t.references :program, index: true, foreign_key: true
      t.references :image_format, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
