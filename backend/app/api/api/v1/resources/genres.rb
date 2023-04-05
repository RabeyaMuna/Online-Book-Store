module API
  module V1
    module Resources
      class Genres < Resources::Base
        before do
          @genre = Genre.find(params[:id]) if params[:id].present?
        end

        resource :genres do
          desc 'Return list of genres'
          get do
            genres = Genre.all
            present paginate(genres), with: Entities::Genre
          end

          desc 'Get a specific genre'
          params do
            requires :id, type: Integer, desc: 'ID of the genre'
          end
          get ':id', root: 'genre' do
            present @genre, with: Entities::Genre
          end

          desc 'Create a genre'
          params do
            requires :genre, type: Hash do
              requires :name, type: String, desc: 'Name of the genre'
            end
          end
          post do
            Genre.create!(params[:genre])
          end

          desc 'Update a genre'
          params do
            requires :genre, type: Hash do
              optional :name, type: String, allow_blank: false
            end
          end
          patch ':id' do
            @genre.update!(params[:genre])
            present @genre, with: Entities::Genre, message: 'Genre Successfully Updated'
          end

          desc 'Delete a genre'
          params do
            requires :id, type: Integer
          end
          delete ':id' do
            if @genre.destroy
              present @genre, with: Entities::Genre, message: 'Genre Successfully Deleted'
            else
              error = { error: @genre.errors.messages, message: 'Genre Failed to Delete' }
              present error
            end
          end
        end
      end
    end
  end
end
