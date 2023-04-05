class CreateBookGenres < ActiveRecord::Migration[6.1]
  def up
    create_table :book_genres do |t|
      t.references :genre, foreign_key: true, index: true, null: false
      t.references :book, foreign_key: true, index: true, null: false

      t.timestamps
    end

    add_index :book_genres, %i(book_id genre_id), unique: true
  end

  def down
    drop_table :book_genres
  end
end
