class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    mail(
      to: email_address_with_name(@user.email, @user.name),
      subject: I18n.t('notice.mailer.welcome'),
    )
  end

  def send_user_report_mail
    @user = params[:user]
    @users = User.all
    mail(
      to: email_address_with_name(@user.email, @user.name),
      subject: I18n.t('notice.mailer.report_generation', resource: User.model_name.human),
    )
  end
end
