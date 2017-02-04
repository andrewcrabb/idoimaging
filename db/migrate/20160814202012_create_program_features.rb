class CreateProgramFeatures < ActiveRecord::Migration
  def change
    create_table :program_features do |t|
      t.integer :weight
      t.references :program, index: true, foreign_key: true
      t.references :feature, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
