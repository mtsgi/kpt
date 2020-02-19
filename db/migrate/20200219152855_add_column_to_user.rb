class AddColumnToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :token, :string, limit: 16
  end
end
