class AddPublishedOnToVersions < ActiveRecord::Migration[5.2]
  def change
    add_column :versions, :published_on, :date
    add_index :versions, :published_on
  end
end
