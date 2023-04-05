class OrderReceiptMailer < ApplicationMailer
  def order_receipt_email
    @order = params[:order]
    pdf = OrderReceiptPdf.call(@order)
    attachments['order_file.pdf'] = { mime_type: 'application/pdf', content: pdf.render }
    mail(to: @order.user.email,
         subject: I18n.t('notice.mailer.order'))
  end
end
