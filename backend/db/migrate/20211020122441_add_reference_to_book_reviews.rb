class AddReferenceToBookReviews < ActiveRecord::Migration[6.1]
  def up
    add_reference :book_reviews, :book, foreign_key: true, index: true, null: false
    add_reference :book_reviews, :user, foreign_key: true, index: true, null: false
  end

  def down
    remove_reference :book_reviews, :book, foreign_key: true, index: true, null: false
    remove_reference :book_reviews, :user, foreign_key: true, index: true, null: false
  end
end
