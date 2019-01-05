class AddLastSeenAndLastTestedToVersions < ActiveRecord::Migration[5.2]
  def change
    add_column :versions, :last_seen, :date
    add_index :versions, :last_seen
    add_column :versions, :last_tested, :date
    add_index :versions, :last_tested
  end
end
