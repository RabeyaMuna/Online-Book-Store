class ChangeAddressBillAttributesOfOrders < ActiveRecord::Migration[6.1]
  def up
    change_column_null :orders, :delivery_address, true
    change_column :orders, :total_bill, :decimal, precision: 8, scale: 2, default: 0.0
  end

  def down
    change_column_null :orders, :delivery_address, false
    change_column :orders, :total_bill, :decimal, precision: 8, scale: 2, default: nil
  end
end
