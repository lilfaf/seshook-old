class AddUserIdToPhotosAndAlbums < ActiveRecord::Migration
  def change
    add_column :photos, :user_id, :integer
    add_column :albums, :user_id, :integer

    add_index :photos, :user_id
    add_index :albums, :user_id
  end
end
