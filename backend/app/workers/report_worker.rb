class ReportWorker
  include Sidekiq::Worker 

  sidekiq_options retry: false

  def perform(current_user)
    UserMailer.with(user: current_user).send_user_report_mail.deliver_later
  end
end
