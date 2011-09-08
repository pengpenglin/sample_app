SampleApp::Application.routes.draw do

  # We use RESTFul URL pattern to organize
  # controller(action) ---> model ---> view
  # such get "users/new" will be mapped to 
  # RESTFul pattern that require the server
  # to render a page for new user creation,
  # so this single line will be comment out
  # since we now use resources route
  # get "users/new"
  resources :users

  get "pages/home"
  get "pages/contact"
  get "pages/about"
  get "pages/help"

  # match '/',     :to => 'pages#home' # This is same as root :to => 'pages#home'
  root             :to => 'pages#home'
  match '/contact',:to => 'pages#contact'
  match '/about',  :to => 'pages#about'
  match '/help',   :to => 'pages#help'
  match '/signup', :to => 'users#new'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can  the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
