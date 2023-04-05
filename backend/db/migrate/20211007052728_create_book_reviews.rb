class CreateBookReviews < ActiveRecord::Migration[6.1]
  def up
    create_table :book_reviews do |t|
      t.text :review, null: false
      t.integer :rating, index: true, default: 1, null: false

      t.timestamps
    end
  end

  def down
    drop_table :book_reviews
  end
end
