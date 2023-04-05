module API
  class Base < Grape::API
    include API::ExceptionHandling
    version 'v1', using: :path
    format :json
    prefix :api

    mount API::V1::Resources::Base
  end
end
