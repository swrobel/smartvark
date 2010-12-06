Smartvark::Application.routes.draw do
  root :to => 'welcome#deals'
  resources :comments
  resources :redemptions
  resources :businesses
  resources :offers
  resources :categories
  #resources :users
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  match 'biz' => 'welcome#forbusiness', :as => :biz
  match 'about' => 'welcome#about', :as => :about
  match 'privacy' => 'welcome#privacypolicy', :as => :privacy
  match 'admin' => 'offers#index', :as => :admin
  match 'mydeals/:category_id' => 'welcome#mydeals', :as => :category_mydeals
  match 'dealdashboard/' => 'welcome#dealdashboard', :as => :dealdashboard
  match 'deals' => 'welcome#deals', :as => :deals
  match 'mydeals' => 'welcome#mydeals', :as => :mydeals
  match 'myprofile' => 'welcome#myprofile', :as => :myprofile
  match 'printdeal/:id' => 'welcome#printdeal', :as => :printdeal, :constraints => { :id => /.*/ }
  match 'search/:category_id' => 'welcome#search', :as => :search, :via => :get
  match 'viewbusiness/:id' => 'welcome#viewbusiness', :as => :viewbusiness, :constraints => { :id => /.*/ }
  match 'viewdeal/:id' => 'welcome#viewdeal', :as => :viewdeal, :constraints => { :id => /.*/ }
  match 'shout/:id' => 'welcome#shout', :as => :shout, :via => :post
  match 'contact' => 'welcome#contact', :as => :contact, :via => :get
  match '/m' => 'm#deals', :as => :mobile_deals
  match '/m/filter/:category_id' => 'm#filter', :as => :mobile_filter, :via => :get
  match '/m/search_results' => 'm#search_results', :as => :mobile_search, :via => :post
  match '/m/viewbusiness/:id' => 'm#viewbusiness', :as => :mobile_viewbusiness, :constraints => { :id => /.*/ }
  match '/m/viewdeal/:id' => 'm#viewdeal', :as => :mobile_viewdeal, :constraints => { :id => /.*/ }
  match '/m/redeem/:id' => 'm#redeem', :as => :mobile_redeem, :constraints => { :id => /.*/ }
  match '/m/search_results' => 'm#search_results', :as => :mobile_search_results, :via => :post
  match '/:controller(/:action(/:id))'
end
