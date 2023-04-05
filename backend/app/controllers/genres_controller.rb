class GenresController < ApplicationController
  load_and_authorize_resource

  skip_before_action :require_login, only: %i(index show)

  def index
    @limit = params.dig(:genre, :limit) ? params[:genre][:limit] : Genre.default_per_page
    @q = Genre.ransack(params[:q])
    @genres = @q.result(distinct: true).page(params[:page]).per(@limit)
  end

  def show
    @genre = Genre.find(params[:id])
    @q = @genre.books.ransack(params[:q])
    @books = @q.result.page(params[:page])
  end

  def create
    @genre = Genre.new(genre_params)

    if @genre.save
      flash[:success] = I18n.t('notice.create.success', resource: Genre.model_name.human)
      redirect_to genres_path
    else
      flash[:error] = I18n.t('notice.create.fail', resource: Genre.model_name.human)
      render :new
    end
  end

  def update
    if @genre.update(genre_params)
      flash[:notice] = I18n.t('notice.update.success', resource: Genre.model_name.human)
      redirect_to genres_path
    else
      flash[:error] = I18n.t('notice.update.fail', resource: Genre.model_name.human)
      render :edit
    end
  end

  def destroy
    if @genre.destroy
      flash[:success] = I18n.t('notice.delete.success', resource: Genre.model_name.human)
    else
      flash[:error] = I18n.t('notice.delete.fail', resource: Genre.model_name.human)
    end
    redirect_to genres_path
  end

  private

  def genre_params
    params.require(:genre).permit(:name)
  end
end
