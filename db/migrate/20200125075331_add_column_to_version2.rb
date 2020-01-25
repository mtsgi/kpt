class AddColumnToVersion2 < ActiveRecord::Migration[6.0]
  def change
    add_column :versions, :def_version, :string
    add_column :versions, :def_id, :string
    add_column :versions, :def_name, :string
    add_column :versions, :def_author, :string
  end
end
