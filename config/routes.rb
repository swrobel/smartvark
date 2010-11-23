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
  map.root              :controller => "welcome", :action => :deals
  map.biz               'biz', :controller => "welcome", :action => :forbusiness
  map.about             'about', :controller => "welcome", :action => :about
  map.privacy           'privacy', :controller => "welcome", :action => :privacypolicy
  map.admin             'admin', :controller => "offers"
  map.category_mydeals  'mydeals/:category_id', :controller => "welcome", :action => :mydeals
  map.dealdashboard     'dealdashboard/', :controller => "welcome", :action => :dealdashboard
  map.deals             'deals', :controller => "welcome", :action => :deals
  map.mydeals           'mydeals', :controller => "welcome", :action => :mydeals
  map.myprofile         'myprofile', :controller => "welcome", :action => :myprofile
  map.printdeal         'printdeal/:id', :controller => "welcome", :action => :printdeal, :requirements => { :id => /.*/ }
  map.search            'search/:category_id', :controller => "welcome", :action => :search, :conditions => { :method => :get }
  map.viewbusiness      'viewbusiness/:id', :controller => "welcome", :action => :viewbusiness, :requirements => { :id => /.*/ }
  map.viewdeal          'viewdeal/:id', :controller => "welcome", :action => :viewdeal, :requirements => { :id => /.*/ }
  map.shout             'shout/:id', :controller => "welcome", :action => :shout, :conditions => { :method => :post }
  map.contact           'contact', :controller => "welcome", :action => :contact, :conditions => { :method => :get }

  map.mobile_filter     '/m/filter/:category_id', :controller => "m", :action => :filter, :conditions => { :method => :get }
  map.mobile_search     '/m/search_results', :controller => "m", :action => :search_results, :conditions => { :method => :post }
  map.mobile_viewbusiness      '/m/viewbusiness/:id', :controller => "m", :action => :viewbusiness, :requirements => { :id => /.*/ }
  map.mobile_viewdeal      '/m/viewdeal/:id', :controller => "m", :action => :viewdeal, :requirements => { :id => /.*/ }
  map.mobile_redeem      '/m/redeem/:id', :controller => "m", :action => :redeem, :requirements => { :id => /.*/ }


  map.logout '/logout',:controller => 'user_sessions', :action => :destroy

  # config/routes.rb
  map.resource :account, :controller => "users"
  map.resources :users

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  map.root :controller => "welcome"
end
