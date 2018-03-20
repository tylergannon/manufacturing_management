# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  resources :notes, except: :index, constraints: { format: :js }

  concern :labellable do
    resources :carton_labels,
              only: :index,
              constraints: {format: :pdf},
              controller: 'labels/carton_labels'
    resources :box_labels,
              only: :index,
              constraints: {format: :pdf},
              controller: 'labels/box_labels'
  end

  resources :batches, concerns: :labellable, except: [:index, :destroy] do
    resources :events, only: [:show, :update]
    collection do
      %w(scheduled started qa accepted shipped rejected).each do |action|
        get action, to: 'batches#index', defaults: { scope: "with_#{action}_state" }
      end
      get :search, constraints: { format: 'json' }
      get :index, to: 'batches#index', defaults: { scope: 'listing' },
                  constraints: { format: 'html' }
      get :index, to: 'batches#csv_index', constraints: { format: 'csv' }
      get :recent, to: 'batches#index', defaults: { scope: 'recent' }
      get :current, to: 'batches#index', defaults: { scope: 'current' }
    end

    member do
      [:add_to_shipment, :overview, :marinade, :feedback, :photos].each do |action|
        get action, to: 'batches#show', defaults: { view: action.to_s }
      end
    end

    resources :feedbacks, controller: :batch_feedbacks
  end

  post 'shipments/:id/event/:event_id', to: 'shipments#workflow_event', as: :shipment_event

  resources :shipments, concerns: :labellable do
    member do
      post :add_batch
      post :workflow_event
      get :prepare_for_shipping
      get :shipping_preparations
      get :shipped
      get :secure_download
    end

    [:all, :recent].each do |action|
      get action, on: :collection, to: 'shipments#index', defaults: { view: action.to_s }
    end
  end

  resources :recipes do
    resources :recipe_ingredients
  end

  resources :flavors, only: [] do
    resources :recipes do
      post :sort, on: :collection
      post :copy, on: :member
    end
  end

  resources :ingredients do
    get :plan, on: :collection
  end
  resources :photos do
    get :secure_download, on: :member
  end

  resources :skus do
    get :labels, on: :member
  end

  get 'recipes/current', to: 'recipes#current', as: :current_recipes

  authenticate :user, ->(u) { u.admin? || u.admin } do
    namespace :dashboard do
      root to: 'projects#index'
      resources :tasks do
        post :complete, on: :member
      end
      resources :projects, only: [:index, :update, :destroy]
    end

    namespace :manual do
      resources :process_flows do
        member do
          get :history
        end
      end
      post :markdown, to: 'markdown#show', constraints: { format: :json }
      resources :standard_operating_procedures do
        member do
          get :history
        end
      end
    end

    namespace :admin do
      resources :purchase_orders do
        post :event, on: :member
        get :download_purchase_order, on: :member
      end
      resources :users
      resources :shipments
      resources :batches
      resources :flavors
      resources :recipes
      resources :ingredients
      resources :fulfillment_warehouses
      root to: 'users#index'
      mount Sidekiq::Web => '/sidekiq'
    end
  end

  devise_for :users, controllers: {
    omniauth_callbacks: 'auth/omniauth_callbacks',
    passwords: 'auth/passwords'
  }

  root to: 'batches#index'

  # mount ActionCable.server => '/cable'
end
