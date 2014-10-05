Hopscotch::Application.routes.draw do
  
  resources :registrations

  resources :hops

  resources :users

  root to: 'main#bac', as: 'bac'

  get "login" => "auth#login", :as => :login
  get "logout" => "auth#logout", :as => :logout
  post "do_login" => "auth#do_login", :as => :do_login
  

  get "bac" => "main#get_bac", :as => :get_bac
  post "bac" => "main#set_bac", :as => :set_bac
  get "admin" => "main#admin", :as => :admin

  get "options" => "main#choose", :as => :choose
  get "options/bars" => "main#bars", :as => :bars
  get "options/food" => "main#food", :as => :food
  get "options/uber" => "main#uber", :as => :uber
  get "options/twilio" => "main#twilio", :as => :twilio

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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
