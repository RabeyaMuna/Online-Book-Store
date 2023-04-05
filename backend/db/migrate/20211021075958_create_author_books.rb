class CreateAuthorBooks < ActiveRecord::Migration[6.1]
  def up
    create_table :author_books do |t|
      t.references :author, null: false, foreign_key: true, index: true
      t.references :book, null: false, foreign_key: true, index: true

      t.timestamps
    end
    add_index :author_books, %i(author_id book_id), unique: true
  end

  def down 
    drop_table :author_books
  end 
end
