class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :status, null: false, default: "regular"

      t.timestamps
    end
    add_index :users, :email_address, unique: true
  end
end