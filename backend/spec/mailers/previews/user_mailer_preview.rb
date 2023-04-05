# Check mailer previews locally by http://localhost:3000/rails/mailers

class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.with(user: User.first).welcome_email
  end

  def send_user_report_mail
    UserMailer.with(user: User.first).send_user_report_mail
  end
end
