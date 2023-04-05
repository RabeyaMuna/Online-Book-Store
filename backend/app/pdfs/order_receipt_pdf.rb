class OrderReceiptPdf < BasePdf
  def call
    add_order_tittle
    create_order_table

    self
  end

  private

  def add_order_tittle
    text 'Ordered by: ' + object.user.name, size: 30, style: :bold
  end

  def create_order_table
    move_down 20
    table(table_data) do
      row(0).font_style = :bold
      columns(1..3).align = :right
      self.row_colors = %w(DDDDDD FFFFFF)
      self.header = true
    end

    move_down 20
    text 'Total Bill: tk ' + object.total_bill.to_s, size: 20, style: :bold
  end

  def table_data
    table_of_items = []
    @count = 0
    table_of_items << table_header
    table_of_items += object.order_items.map do |item|
      @count += 1
      book = Book.find(item.book_id)
      [@count, book.name, item.quantity, book.price.round,
       (item.quantity * book.price).round,]
    end
  end

  def table_header
    table_header = ['Item No', 'Product', 'Qty', 'Unit Price', 'Full Price']
  end
end
