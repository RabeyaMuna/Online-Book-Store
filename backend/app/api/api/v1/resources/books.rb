module API
  module V1
    module Resources
      class Books < Resources::Base

        helpers do
          def find_book
            Book.find(params[:id])
          end
        end

        resource :books do
          desc 'Get all books'
          get do
            books = Book.all
            present paginate(books), with: Entities::Book
          end

          desc 'Get a specific book'
          params do
            requires :id, type: Integer, desc: 'ID of the book'
          end
          get ':id', root: 'book' do
            present find_book, with: Entities::Book
          end

          route_param :id, type: Integer do
            desc 'Get authors of a specific book'
            get :book_authors do
              authors = find_book.authors
              present paginate(authors), with: Entities::Author
            end
          end

          desc 'Create a book'
          params do
            requires :book, type: Hash do
              requires :name, type: String, desc: 'Name of the book'
              requires :price, type: Float, desc: 'Price of the book'
              requires :total_copies, type: Integer, desc: 'Total Copies of the book'
            end
          end
          post do
            Book.create!(params[:book])
          end

          desc 'Update a book'
          params do
            requires :book, type: Hash do
              optional :name, type: String, allow_blank: false
              optional :price, type: Float, allow_blank: false
              optional :total_copies, type: Integer
            end
          end
          patch ':id' do
            book = find_book
            book.update!(params[:book])
            present book, with: Entities::Book, message: 'Book Successfully Updated'
          end

          desc 'Delete a book'
          params do
            requires :id, type: Integer
          end
          delete ':id' do
            book = find_book
            if book.destroy
              present book, with: Entities::Book, message: 'Book Successfully Deleted'
            else
              error = { error: book.errors.messages, message: 'Book Failed to Delete' }
              present error
            end
          end
        end
      end
    end
  end
end
