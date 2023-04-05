module API
  module V1
    module Entities
      class Book < Entities::Base
        expose :name
        expose :price
        expose :total_copies
      end
    end
  end
end
