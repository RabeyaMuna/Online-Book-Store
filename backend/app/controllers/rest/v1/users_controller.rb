module Rest
  module V1
    class UsersController < RestController
      before_action :find_user, only: %i(show update destroy)

      def index
        @limit = params.dig(:user, :limit) ? params[:user][:limit] : User.default_per_page
        @users = sorted_index(User).page(params[:page]).per(@limit)

        render_json(@users)
      end

      def show
        render_json(@user)
      end

      def create
        user = User.new(user_params)
        if user.save
          render_json(user)
        else
          render json: { error: 'Unable to create User.' }, status: :bad_request
        end
      end

      def update
        if @user.update(user_params)
          render_json(@user)
        else
          render json: { error: 'Unable to update user.' }, status: :bad_request
        end
      end

      def destroy
        if @user.destroy
          render json: { message: 'Deleted the user', data: @user }, status: :ok
        else
          render json: { error: 'Unable to delete User.' }, status: :bad_request
        end
      end

      private

      def render_json(user)
        render json: UserSerializer.new(user)
      end

      def find_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :email, :password, :phone, :role)
      end
    end
  end
end
