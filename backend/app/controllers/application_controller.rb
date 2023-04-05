class ApplicationController < ActionController::Base
  include Clearance::Controller

  around_action :switch_locale
  before_action :require_login
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from CanCan::AccessDenied, with: :access_denied

  def record_not_found(error)
    flash[:error] = t('notice.not_found', resource: error.model)
    redirect_to root_path
  end

  private

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def humanize(model)
    model.model_name.human
  end

  def sorted_index(model)
    @query = model.ransack(params[:q])
    result = @query.result(distinct: true)
    return result unless params[:q].nil?

    result.order(created_at: :desc)
  end

  def access_denied(error)
    flash[:error] = error.message
    redirect_to root_path
  end
end
