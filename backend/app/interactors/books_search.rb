class BooksSearch
  include Interactor

  delegate :search_text, :page, to: :context

  def call
    context.book_id_list = []

    load_authers_booklist
    load_genres_booklist

    context.booklist = Book.search_book(search_text, context.book_id_list.flatten).page(page)
  end

  private

  def load_authers_booklist
    authors = Author.search_author(search_text)

    authors.each do |author|
      context.book_id_list << author.books.ids
    end
  end

  def load_genres_booklist
    genres = Genre.search_genre(search_text)

    genres.each do |genre|
      context.book_id_list << genre.books.ids
    end
  end
end
