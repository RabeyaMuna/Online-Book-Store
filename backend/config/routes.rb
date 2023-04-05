Rails.application.routes.draw do
  constraints Clearance::Constraints::SignedIn.new { |user| user.admin? } do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  scope '(:locale)', locale: /en|bn/ do
    mount API::Base, at: '/'

    resources :users
    resources :books
    resources :authors
    resources :genres
    resources :orders do
      post :update_status, on: :member
      resources :order_items, only: %i(update destroy)
    end
    # Renamed it as 'Rest' to keep the REST and Grape both API
    # implementation intact in the project
    # because this project is developed for learning purpose
    namespace :rest do
      namespace :v1 do
        resources :authors
        resources :users
        resources :books
        resources :orders
        resources :genres
      end
    end

    resource :session, controller: 'clearance/sessions', only: [:create]
    resources :passwords, controller: 'clearance/passwords', only: %i(create new)

    resources :users, only: [:create] do
      resource :password,
               controller: 'clearance/passwords',
               only: %i(edit update)
    end

    get :sign_in, to: 'clearance/sessions#new', as: 'sign_in'
    post :sign_in, to: 'clearance/sessions#create'
    delete :sign_out, to: 'clearance/sessions#destroy', as: 'sign_out'
    get :sign_up, to: 'registrations#new', as: 'sign_up'
    post :sign_up, to: 'registrations#create'

    get :search_without_gem, to: 'search#search_without_gem', as: :search_without_gem
    get :search_with_gem, to: 'search#search_with_gem', as: :search_with_gem

    get :send_user_report_mail, to: 'users#send_user_report_mail', as: :send_user_report_mail

    root 'welcome#index'
  end
end
