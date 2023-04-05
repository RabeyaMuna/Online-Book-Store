module API
  module V1
    module Resources
      class Base < Grape::API
        mount Resources::Users
        include Grape::Kaminari

        params do
          use :pagination, per_page: 2, max_per_page: 3
        end

        mount Resources::Orders
        mount Resources::Authors
        mount Resources::Books
        mount Resources::Genres
      end
    end
  end
end
