class BasePdf < Prawn::Document
  attr_reader :object

  def initialize(object)
    super(
      page_size: 'A4',
      page_layout: :portrait,
      margin: 30,
      top_margin: 50
    )
    @object = object
  end

  def self.call(object)
    new(object).call
  end
end
