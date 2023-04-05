module Rest
  module V1
    class BooksController < RestController
      before_action :find_book, only: %i(show update destroy)

      def index
        @books = Book.all
        render_json_data(@books)
      end

      def show
        render_json_data(@book)
      end

      def create
        @book = Book.new(book_params)

        if @book.save
          render_json_data(@book)
        else
          render json: { message: 'Unable to create book.' }, status: :bad_request
        end
      end

      def update
        if @book.update(book_params)
          render json: { data: BookSerializer.new(@book),
                         message: 'Book successfully updated.', },
                 status: :ok
        else
          render json: { error: 'Unable to update Book.' }, status: :bad_request
        end
      end

      def destroy
        if @book.destroy
          render json: { data: BookSerializer.new(@book),
                         message: 'Book successfully deleted.', },
                 status: :ok
        else
          render json: { error: 'Unable to delete Book.' }, status: :bad_request
        end
      end

      def find_book
        @book = Book.find(params[:id])
      end

      def book_params
        params.require(:book).permit(
          :name,
          :price,
          :total_copies,
          :copies_sold,
          :publication_year,
        )
      end

      def render_json_data(resource)
        render json: BookSerializer.new(resource)
      end
    end
  end
end
