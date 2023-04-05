# Reamed it as 'Rest' to keep the REST and Grape both API 
# implementation intact in the project
# because this project is developed for learning purpose
class RestController < ApplicationController
  skip_before_action :require_login
  skip_before_action :verify_authenticity_token

  def render_json(status_msg, translate, data, status_id)
    render json: { status: status_msg, translate: translate, data: GenreSerializer.new(data) },
           status: status_id
  end
end
