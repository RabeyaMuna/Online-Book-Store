require 'rails_helper'

RSpec.describe OrderReceiptMailer do
  let(:user) { FactoryBot.create(:user) }
  let!(:order) { FactoryBot.create(:order) }
  let(:mail) { OrderReceiptMailer.with(order: order).order_receipt_email }

  describe 'Order placed email' do
    it 'renders the headers' do
      expect(mail.subject).to eq(I18n.t('notice.mailer.order'))
      expect(mail.to).to eq([order.user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("Dear #{order.user.name},")
    end

    it 'returns attached pdf' do
      expect(mail.attachments.first.filename).to match('order_file.pdf')
      expect(mail.attachments.first.content_type).to match('application/pdf')
      expect(mail.attachments.length).to match(1)
    end
  end
end
