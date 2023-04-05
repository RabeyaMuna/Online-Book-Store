class CreateAuthors < ActiveRecord::Migration[6.1]
  def up 
    create_table :authors do |t|
      t.string :full_name, index: true, null: false
      t.string :nick_name, index: true, null: false
      t.text :biography, null: false

      t.timestamps
    end
  end

  def down
    drop_table :authors
  end
end
