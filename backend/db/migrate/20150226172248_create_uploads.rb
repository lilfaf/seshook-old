class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.binary     :uuid, length: 16
      t.string     :filename
      t.string     :content_type
      t.integer    :state
      t.string     :upload_type
      t.integer    :user_id
      t.references :uploadable, polymorphic: true, index: true
      t.datetime   :pending_at
      t.datetime   :imported_at

      t.timestamps null: false
    end
  end
end
