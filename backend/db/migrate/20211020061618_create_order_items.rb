class CreateOrderItems < ActiveRecord::Migration[6.1]
  def up
    create_table :order_items do |t|
      t.integer :quantity, null: false
      t.references :book, foreign_key: true, null: false, index: true
      t.references :order, foreign_key: true, null: false, index: true

      t.timestamps
    end
  end

  def down
    drop_table :order_items
  end
end
