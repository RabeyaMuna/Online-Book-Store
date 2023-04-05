module Rest
  module V1
    class GenresController < RestController
      before_action :find_genre, only: %i(show update destroy)

      def index
        @genres = Genre.order(created_at: :desc)
        render_json('SUCCESS', translate('notice.load.success'), @genres, :ok)
      end

      def show
        render_json('SUCCESS', translate('notice.load.success'), @genre, :ok)
      end

      def create
        @genre = Genre.new(genre_params)
        if @genre.save
          render_json('SUCCESS', translate('notice.create.success'), @genre, :ok)
        else
          render_json('ERROR', translate('notice.create.fail'), @genre, :bad_request)
        end
      end

      def destroy
        if @genre.destroy
          render_json('SUCCESS', translate('notice.delete.success'), @genre, :ok)
        else
          render_json('ERROR', translate('notice.delete.fail'), @genre, :bad_request)
        end
      end

      def update
        if @genre.update(genre_params)
          render_json('SUCCESS', translate('notice.update.success'), @genre, :ok)
        else
          render_json('ERROR', translate('notice.update.fail'), @genre, :bad_request)
        end
      end

      private

      def genre_params
        params.require(:genre).permit(:name)
      end

      def find_genre
        @genre = Genre.find(params[:id])
      end

      def translate(i18n_location)
        I18n.t(i18n_location, resource: Genre.model_name.human)
      end
    end
  end
end
