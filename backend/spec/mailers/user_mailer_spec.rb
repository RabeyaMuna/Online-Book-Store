require 'rails_helper'

RSpec.describe UserMailer do
  let(:user) { FactoryBot.create(:user, email: 'hello@gmail.com') }
  let(:mail_1) { UserMailer.with(user: user).welcome_email }
  let(:mail_2) { UserMailer.with(user: user).send_user_report_mail }

  describe 'welcome_email' do
    it 'renders the headers' do
      expect(mail_1.subject).to eq(I18n.t('notice.mailer.welcome'))
      expect(mail_1.to).to eq([user.email])
      expect(mail_1.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail_1.body.encoded).to match("Welcome to Online Book Store, #{user.name}")
    end
  end

  describe 'send_user_report_mail' do
    it 'renders the headers' do
      expect(mail_2.subject).to eq(I18n.t('notice.mailer.report_generation', resource: User.model_name.human))
      expect(mail_2.to).to eq([user.email])
      expect(mail_2.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail_2.body.encoded).to match('List of Users')
    end
  end
end
