class BooksController < ApplicationController
  load_and_authorize_resource

  skip_before_action :require_login, only: %i(index show)

  def index
    @limit = params.dig(:book, :limit) ? params[:book][:limit] : Book.default_per_page
    @books = sorted_index(Book).page(params[:page]).per(@limit)
  end

  def create
    @book = Book.new(book_params)

    if @book.save
      flash[:success] = I18n.t('notice.create.success', resource: humanize(Book))
      redirect_to books_path
    else
      flash[:error] = I18n.t('notice.create.fail', resource: humanize(Book))
      render :new
    end
  end

  def update
    if @book.update(book_params)
      flash[:notice] = I18n.t('notice.update.success', resource: humanize(Book))
      redirect_to books_path
    else
      flash[:error] = I18n.t('notice.update.fail', resource: humanize(Book))
      render :edit
    end
  end

  def destroy
    if @book.destroy
      flash[:success] = I18n.t('notice.delete.success', resource: humanize(Book))
    else
      flash[:error] = I18n.t('notice.delete.fail', resource: humanize(Book))
    end
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(
      :name,
      :price,
      :total_copies,
      :copies_sold,
      :publication_year,
      :avatar
    )
  end
end
