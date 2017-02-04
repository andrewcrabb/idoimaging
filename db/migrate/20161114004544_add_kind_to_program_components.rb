class AddKindToProgramComponents < ActiveRecord::Migration
  def change
    add_column :program_components, :kind, :string
  end
end
