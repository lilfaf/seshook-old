class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.string   :name
      t.integer  :status, null: false, default: 0
      t.st_point :lonlat, null: false, geographic: true
      t.integer  :user_id

      t.timestamps null: false
    end

    add_index :spots, :status
    add_index :spots, :lonlat, using: :gist
    add_index :spots, :user_id
  end
end
