class CreateVersions < ActiveRecord::Migration[6.0]
  def change
    create_table :versions do |t|
      t.string :name
      t.string :desc
      t.string :path
      t.string :public_uid

      t.timestamps
    end
  end
end
