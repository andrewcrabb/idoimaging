class RenameProgramKindToProgramProgramKind < ActiveRecord::Migration
  def change
    rename_column :programs, :kind, :program_kind
    # add_index :programs, :program_kind
  end
end
