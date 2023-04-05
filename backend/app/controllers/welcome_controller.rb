class WelcomeController < ApplicationController
  skip_before_action :require_login
  DEFAULT_LIMIT = 15

  def index
    limit = if params.dig(:book, :limit) && params[:book][:limit].to_i > 0
              params[:book][:limit]
            else
              DEFAULT_LIMIT
            end

    title = params[:book][:title] if params.dig(:book, :title)
    @latest_collection =
      Book.order(created_at: :desc).limit(title == 'Latest Collection' ? limit : DEFAULT_LIMIT)
    @best_sellers =
      Book.order(copies_sold: :desc).limit(title == 'Best Sellers' ? limit : DEFAULT_LIMIT)
    @recently_published =
      Book.order(publication_year: :desc).limit(title == 'Recently Published' ? limit : DEFAULT_LIMIT)
  end
end
