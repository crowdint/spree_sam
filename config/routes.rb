Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do

      devise_for :spree_user,
        class_name: 'Spree::User',
        controllers: { sessions: 'spree/api/v1/user_sessions' }

      resources :stats, only: [:index]
      resources :shipping_categories, only: [:index, :show]

    end
  end

end
