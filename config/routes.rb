ActionController::Routing::Routes.draw do |map|
  map.resources :comments

  map.resources :redemptions

  map.resources :businesses

  map.resources :offers

  map.resources :categories

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  # config/routes.rb
  map.resource :user_session

  map.mydeals 'mydeals', :controller => "welcome", :action => :mydeals
  map.category_mydeals 'mydeals/:category_id', :controller => "welcome", :action => :mydeals
  map.viewdeal 'viewdeal/:id', :controller => "welcome", :action => :viewdeal
  map.deals 'deals', :controller => "welcome", :action => :deals
  map.search 'search/:category_id', :controller => "welcome", :action => :search, :conditions => { :method => :get }
  map.admin 'admin', :controller => "offers"

  map.root :controller => "welcome"

  map.login '/login', :controller => 'user_sessions', :action => :new
  map.logout '/logout',:controller => 'user_sessions', :action => :destroy

  # config/routes.rb
  map.resource :account, :controller => "users"
  map.resources :users

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
