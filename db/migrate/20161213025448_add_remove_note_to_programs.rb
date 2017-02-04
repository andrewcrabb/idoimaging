class AddRemoveNoteToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :remove_note, :string
  end
end
