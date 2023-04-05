class SearchController < ApplicationController
  skip_before_action :require_login

  def search_without_gem
    redirect_to root_path if params[:search][:search_text].blank?
    results = BooksSearch.call(search_text: params[:search][:search_text], page: params[:page])
    @booklist = results.booklist
  end

  def search_with_gem
    @q = Book.ransack(params[:q])
    @books = @q.result(distinct: true).includes(:author_books, :authors, :book_genres,
                                                :genres).page(params[:page])

    @genre_list = []
    Genre.select(:name).each { |genre| @genre_list << genre.name }
  end
end
