class AuthorsController < ApplicationController
  load_and_authorize_resource

  skip_before_action :require_login, only: %i(index show)

  def index
    @limit = params.dig(:author, :limit) ? params[:author][:limit] : Author.default_per_page
    @authors = sorted_index(Author).page(params[:page]).per(@limit)
  end

  def create
    @author = Author.new(author_params)

    if @author.save
      flash[:success] = I18n.t('notice.create.success', resource: Author.model_name.human)
      redirect_to authors_path
    else
      flash[:error] = I18n.t('notice.create.fail', resource: Author.model_name.human)
      render :new
    end
  end

  def update
    if @author.update(author_params)
      flash[:notice] = I18n.t('notice.update.success', resource: Author.model_name.human)
      redirect_to authors_path
    else
      flash[:error] = I18n.t('notice.update.fail', resource: Author.model_name.human)
      render :edit
    end
  end

  def destroy
    if @author.destroy
      flash[:success] = I18n.t('notice.delete.success', resource: Author.model_name.human)
    else
      flash[:error] = I18n.t('notice.delete.fail', resource: Author.model_name.human)
    end
    redirect_to authors_path
  end

  private

  def author_params
    params.require(:author).permit(:full_name, :nick_name, :biography)
  end
end
