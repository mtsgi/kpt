class CreateApps < ActiveRecord::Migration[6.0]
  def change
    create_table :apps do |t|
      t.integer :user_id
      t.string :appid
      t.string :name
      t.string :desc

      t.timestamps
    end
  end
end
