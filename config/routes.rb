Rails.application.routes.draw do

  # devise_for :users
  # devise_for :admin_users, ActiveAdmin::Devise.config

  # Trying taking this out.

  # scope "/admin" do
  #   resources :users
  # end

  devise_for :users, controllers: {sessions: 'users/sessions', registrations: 'users/registrations', passwords: 'users/passwords', confirmations: 'users/confirmations'}
  # devise_for :users      , ActiveAdmin::Devise.config
  # devise_for :admin_users, ActiveAdmin::Devise.config
  # This causes author.rb errors on 'db:create'
  ActiveAdmin.routes(self)

  resources :authors, only: [:show] {}
  # Come back to ImageFormat.  
  #   index: Is this relevant?  Could redirect to a wiki page.
  #   show:  Redirect to a wiki page
  resources :image_formats, only: [:index, :show]

  resources :features
  resources :users, only: [:show]
  resources :resources

  resources :programs, only: [:index, :show] do
    collection do
      get "search"
    end
  end
  put 'programs/:id/rating' => 'programs#rating', as: :rating
  put 'programs/:id/calculate_rating' => 'programs#calculate_rating', as: :calculate_rating

  get 'about' => "pages#about"
  get 'home'  => "pages#home"
  get 'search' => "programs#search"
  get 'turku_2017' => "pages#turku_2017"
  root "pages#home"

  # Program controller is for backward compatibility with old site 
  # get 'program/index'
  # get 'program/show'
  resources :program, only: [:index, :show]

get '*unmatched_route', :to => 'application#raise_not_found!'

  # get 'pages/home' => 'high_voltage/pages#home', id: 'home'
  # root "pages/home", page: "home"
  # get "/pages/:page" => "pages#show"

  # get "/pages/studies_summary" => "pages#show", as: :studies_summary
  # get "/pages/storage_objects_summary" => "pages#show", as: :storage_objects_summary



  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
