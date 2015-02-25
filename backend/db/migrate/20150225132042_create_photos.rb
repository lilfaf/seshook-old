class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string     :file,         null: false
      t.string     :content_type, null: false
      t.integer    :size,         null: false
      t.string     :key
      t.string     :etag
      t.references :photoable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
