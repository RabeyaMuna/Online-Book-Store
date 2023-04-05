class CreateBooks < ActiveRecord::Migration[6.1]
  def up
    create_table :books do |t|
      t.citext :name, index: true, null: false
      t.float :price, null: false
      t.integer :total_copies, null: false
      t.integer :copies_sold, null: false, default: 0
      t.date :publication_year, index: true

      t.timestamps
    end
  end

  def down
    drop_table :books
  end
end
