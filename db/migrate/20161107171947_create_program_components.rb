class CreateProgramComponents < ActiveRecord::Migration
  def change
    create_table :program_components do |t|
      # I get problems if 'foreign_key: true' is here.
      t.references :including_program, index: true
      t.references :included_program , index: true
      t.timestamps null: false
    end
  end
end
