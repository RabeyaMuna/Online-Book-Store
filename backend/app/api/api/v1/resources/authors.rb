module API
  module V1
    module Resources
      class Authors < Resources::Base

        helpers do
          def find_author
            Author.find(params[:id])
          end
        end

        resource :authors do
          desc 'Return list of Authors'
          get do
            authors = Author.all
            present paginate(authors), with: Entities::Author
          end

          desc 'Return a specific Author'
          route_param :id do
            get do
              author = find_author
              present author
            end
          end

          desc 'Return Books written by the author'
          route_param :id do
            get :written_books do
              author = find_author
              written_books = author.books
              present written_books, with: Entities::Book
            end
          end

          desc 'Create an Author'
          params do
            requires :author, type: Hash do
              requires :full_name, type: String, allow_blank: false
              requires :nick_name, type: String, allow_blank: false
              requires :biography, type: String, allow_blank: false
            end
          end
          post do
            Author.create!(params[:author])
          end

          desc 'Update an author'
          params do
            requires :author, type: Hash do
              optional :full_name, type: String, allow_blank: false
              optional :nick_name, type: String, allow_blank: false
              optional :biography, type: String, allow_blank: false
            end
          end
          patch ':id' do
            author = find_author
            author.update!(params[:author])
            present author, with: Entities::Author
          end

          desc 'Delete an Author'
          params do
            requires :id, type: Integer
          end
          delete ':id' do
            author = find_author
            author.destroy!
          end
        end
      end
    end
  end
end
