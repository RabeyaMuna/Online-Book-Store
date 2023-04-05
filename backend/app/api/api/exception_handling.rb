module API
  module ExceptionHandling
    extend ActiveSupport::Concern

    included do
      rescue_from Grape::Exceptions::ValidationErrors do |error|
        Rack::Response.new({ message: error.message }.to_json, 400)
      end

      rescue_from ActiveRecord::RecordInvalid do |error|
        Rack::Response.new({ message: error.message }.to_json, 422)
      end

      rescue_from ActiveRecord::RecordNotFound do |error|
        Rack::Response.new({ message: error.message }.to_json, 404)
      end

      rescue_from Exception, StandardError do |error|
        Rack::Response.new({ message: error.full_message }.to_json, 500)
      end
    end
  end
end
