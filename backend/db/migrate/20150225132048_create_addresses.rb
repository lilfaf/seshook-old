class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string     :country_code, null: false
      t.string     :street,       null: false
      t.string     :city,         null: false
      t.string     :zip
      t.string     :state
      t.references :addressable, polymorphic: true, index: true

      t.timestamps null: false
    end

    add_index :addresses, [:street, :city]
  end
end
