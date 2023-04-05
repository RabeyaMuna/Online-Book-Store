require 'spec_helper'

RSpec.describe OrderReceiptPdf do
  let!(:user) { FactoryBot.create(:user) }
  let(:book) { FactoryBot.create(:book) }
  let(:order_item) { FactoryBot.attributes_for(:order_item, book_id: book.id) }
  let(:order) { FactoryBot.create(:order, order_items_attributes: [order_item]) }
  let(:pdf) { described_class.call(order) }
  let(:binary_content) { pdf.render }
  let(:page_analysis) { PDF::Inspector::Page.analyze(binary_content) }
  let(:text_analysis) { PDF::Inspector::Text.analyze(binary_content) }
  let(:pdf_content) { text_analysis.strings.join(' ') }

  describe '#initialize' do
    it 'assigns instance variables on initialization' do
      expect(described_class).to respond_to(:new).with(1).arguments
      expect(pdf.instance_variable_get(:@object)).to eq(order)
    end
  end

  describe 'generated pdf' do
    it 'gets 1 pages of the pdf' do
      expect(page_analysis.pages.count).to eq(1)
    end

    it 'contains customer name' do
      expect(pdf_content).to include(order.user.name)
    end

    it 'contains table header of order' do
      expect(pdf_content).to include(Order.model_name.human, 'Ordered by', 'Item No', 'Product', 'Qty',
                                     'Unit Price', 'Full Price', I18n.t('views.shared.amount'))
    end

    it 'contains total_bill of order' do
      expect(pdf_content).to include(order.total_bill.to_s)
    end
  end
end
