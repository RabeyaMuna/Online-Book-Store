module SerialHelper
  def calculate_serial(model, index)
    params[:page] = 1 if params[:page].nil?
    if @limit.present?
      serial_calculation_with_limit(params[:page], @limit) + index
    else
      serial_calculation_without_limit(model, params[:page]) + index
    end
  end

  private

  def serial_calculation_with_limit(page, limit)
    page.to_i * limit.to_i - limit.to_i
  end

  def serial_calculation_without_limit(model, page)
    (page.to_i - 1) * model.default_per_page
  end
end
