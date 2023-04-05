class RegistrationsController < Clearance::UsersController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      WelcomeRegistrationMail.call(user: @user)

      flash[:success] = I18n.t('notice.create.success', resource: User.model_name.human)
      redirect_to sign_in_path
    else
      flash[:error] = I18n.t('notice.create.fail', resource: User.model_name.human)
      render :new, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :phone)
  end
end
