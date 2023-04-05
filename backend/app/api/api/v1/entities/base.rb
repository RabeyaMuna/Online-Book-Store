module API
  module V1
    module Entities
      class Base < Grape::Entity
        expose :id
      end
    end
  end
end
