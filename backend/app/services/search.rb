class Search < ApplicationService
  attr_accessor :parameter, :page

  def initialize(params)
    @parameter = params[:search][:search_text]
    @page = params[:page]
  end

  def call
    book_id_list = []

    fetch_authors(book_id_list)

    fetch_genres(book_id_list)

    Book.where('name ILIKE ?', "%#{parameter}%").or(Book.where(id: book_id_list)).page(page)
  end

  private

  def fetch_authors(book_id_list)
    authors = Author.where('full_name ILIKE ? OR nick_name ILIKE ? OR biography ILIKE ?', "%#{parameter}%",
                           "%#{parameter}%", "%#{parameter}%")

    authors.each do |author|
      author.books.each do |book|
        book_id_list << book.id
      end
    end
  end

  def fetch_genres(book_id_list)
    genres = Genre.where('name ILIKE ?', "%#{parameter}%")

    genres.each do |genre|
      genre.books.each do |book|
        book_id_list << book.id
      end
    end
  end
end
