module API
  module V1
    module Resources
      class Users < Grape::API
        include API::Resources

        helpers do
          def find_user
            User.find(params[:id])
          end
        end

        resource :users do
          desc 'Get all users'
          get do
            users = User.all
            present users, with: Entities::User
          end

          desc 'Get a specific user with id'
          route_param :id do
            get do
              user = find_user
              present user
            end
          end

          desc 'Create a user'
          params do
            requires :user, type: Hash do
              requires :name, type: String, allow_blank: false
              requires :email, type: String, allow_blank: false
              requires :password, type: String, allow_blank: false
              requires :phone, type: String, allow_blank: false
              optional :role, type: String, allow_blank: false
            end
          end
          post do
            user = User.new(params[:user])
            if user.save
              data = { user: user, message: 'User Successfully Created' }
              present data
            else
              error = { error: user.errors.messages, message: 'User Creation Failed' }
              present error
            end
          end

          desc 'Update a user'
          params do
            requires :user, type: Hash do
              optional :name, type: String, allow_blank: false
              optional :email, type: String, allow_blank: false, regexp: VALID_EMAIL_REGEX
              optional :password, type: String, allow_blank: false
              optional :phone, type: String, allow_blank: false, regexp: VALID_PHONE_REGEX
              optional :role, type: String, allow_blank: false
            end
          end
          route_param :id do
            patch do
              user = find_user
              if user.update(params[:user])
                data = { user: user, message: 'User Successfully Updated' }
                present data
              else
                error = { error: user.errors.messages, message: 'User Failed to Update' }
                present error
              end
            end
          end

          desc 'delete a user'
          route_param :id do
            delete do
              user = find_user
              if user.destroy
                data = { user: user, message: 'User Successfully Deleted' }
                present data
              else
                error = { error: user.errors.messages, message: 'User Failed to Delete' }
                present error
              end
            end
          end
        end
      end
    end
  end
end
