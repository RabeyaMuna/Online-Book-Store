class CreateOrders < ActiveRecord::Migration[6.1]
  def up
    create_table :orders do |t|
      t.integer :order_status, default: 0, index: true, null: false
      t.string :delivery_address, null: false
      t.decimal :total_bill, precision: 8, scale: 2
      t.references :user, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end

  def down
    drop_table :orders
  end
end
