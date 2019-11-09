class AddColumnToVersion < ActiveRecord::Migration[6.0]
  def change
    add_column :versions, :app_id, :integer
  end
end
