class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :email
      t.string :phone_number
      t.text :address
      t.text :cart
      t.string :status

      t.timestamps
    end
  end
end