class AddFacebookOauthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :oauth_token,      :string
    add_column :users, :oauth_expires_at, :datetime

    add_index :users, :oauth_token, unique: true
  end
end
