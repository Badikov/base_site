class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :email
      t.boolean :active, :default => false
      t.boolean :banned, :default => false
      t.string :password_digest
      t.string :auth_token
      t.string :perishable_token

      t.timestamps
    end
    add_index :users, :login, :unique => true
    add_index :users, :email, :unique => true
  end
end
