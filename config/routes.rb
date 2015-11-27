Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do

      resources :orders do
        member do
          put 'approve'
        end
      end
      resources :stats, only: [:index]
      resources :shipping_categories, only: [:index, :show]
      resources :promotions, only: [:index, :show, :create, :update] do
        collection do
          get 'available'
        end
      end
      resources :products do
        member do
          get :stock_items
        end
      end

    end
  end
end
