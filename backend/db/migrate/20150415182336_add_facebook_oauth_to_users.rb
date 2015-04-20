class AddFacebookOauthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_access_token, :string
    add_column :users, :fb_access_token_expires_at, :datetime

    add_index :users, :fb_access_token, unique: true
  end
end
