module API
  module V1
    module Entities
      class User < Entities::Base
        expose :name
        expose :password
        expose :email
        expose :phone
        expose :role
      end
    end
  end
end
