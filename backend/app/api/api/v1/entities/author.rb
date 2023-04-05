module API
  module V1
    module Entities
      class Author < Entities::Base
        expose :full_name
        expose :nick_name
        expose :biography
      end
    end
  end
end
