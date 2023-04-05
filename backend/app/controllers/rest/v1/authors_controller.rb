# Renamed it as 'Rest' to keep the REST and Grape both API
# implementation intact in the project
# because this project is developed for learning purpose
module Rest
  module V1
    class AuthorsController < RestController
      before_action :find_author, only: %i(show update destroy)

      def index
        @authors = Author.all
        render_json(@authors)
      end

      def show
        render_json(@author)
      end

      def create
        @author = Author.new(author_params)

        if @author.save
          render_json(@author)
        else
          render json: { error: 'Unable to create Author.' }, status: :bad_request
        end
      end

      def update
        if @author.update(author_params)
          render_json(@author)
        else
          render json: { error: 'Unable to update Author.' }, status: :bad_request
        end
      end

      def destroy
        if @author.destroy
          render_json(@author)
        else
          render json: { error: 'Unable to delete Author.' }, status: :bad_request
        end
      end

      private

      def author_params
        params.require(:author).permit(:full_name, :nick_name, :biography)
      end

      def find_author
        @author = Author.find(params[:id])
      end

      def render_json(author)
        render json: { author: AuthorSerializer.new(author) }, status: :ok
      end
    end
  end
end
