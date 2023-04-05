class CreateUsers < ActiveRecord::Migration[6.1]
  def up
    enable_extension 'citext'

    create_table :users do |t|
      t.citext :name, index: true, null: false
      t.citext :email, index: { unique: true }, null: false
      t.string :password, null: false
      t.string :phone, index: { unique: true }, limit: 18, null: false
      t.integer :role, index: true, default: 1, null: false

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
