class AddFacebookAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_id, :string
    add_column :users, :birthday,    :date
    add_column :users, :first_name,  :string
    add_column :users, :last_name,   :string
    add_column :users, :username,    :string, null: false
    add_column :users, :locale,      :string
    add_column :users, :verified,    :boolean
    add_column :users, :gender,      :integer, null: false, default: 0

    add_index :users, :facebook_id, unique: true
  end
end