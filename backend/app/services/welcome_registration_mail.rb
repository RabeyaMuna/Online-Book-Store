class WelcomeRegistrationMail
  def initialize(params)
    @user = params[:user]
  end
  
  def self.call(user)
    new(user).call
  end

  def call
    send_welcome_email
  end

  private

  def send_welcome_email
    UserMailer.with(user: @user).welcome_email.deliver_later
  end
end
