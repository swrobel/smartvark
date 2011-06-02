Smartvark::Application.routes.draw do
  root :to => 'welcome#deals'
  resources :comments
  resources :redemptions
  resources :businesses
  resources :offers do
    get 'print', :on => :collection
  end
  resources :categories
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks", :registrations => "registrations" }
  match 'biz' => 'welcome#forbusiness', :as => :biz
  match 'about' => 'welcome#about', :as => :about
  match 'privacy' => 'welcome#privacy_policy', :as => :privacy
  match 'agreement' => 'welcome#merchant_agreement', :as => :agreement
  match 'terms' => 'welcome#terms_of_service', :as => :terms
  #match 'contact' => 'welcome#contact', :as => :contact
  #match 'admin' => 'offers#index', :as => :admin
  match 'dashboard' => 'welcome#dealdashboard', :as => :dealdashboard
  match 'deals' => 'welcome#deals', :as => :deals
  match 'mydeals' => 'welcome#mydeals', :as => :mydeals
  match 'mydeals/:category_id' => 'welcome#mydeals', :as => :category_mydeals
  match 'mypicks' => 'welcome#mypicks', :as => :mypicks
  match 'mypicks/:category_id' => 'welcome#mypicks', :as => :category_mypicks
  match 'myprofile' => 'welcome#myprofile', :as => :myprofile
  match 'deal/:id' => 'welcome#viewdeal', :as => :viewdeal
  match 'redeem/:id' => 'welcome#redeem', :as => :redeem
  match 'search/:category_id' => 'welcome#search', :as => :search, :via => :get
  match 'biz/:id' => 'welcome#viewbusiness', :as => :viewbusiness
  match 'shout/:id' => 'welcome#shout', :as => :shout, :via => :post
  match 'set_opinion' => 'welcome#set_opinion', :as => :set_opinion, :via => :post
  match 'undo_last_action' => 'welcome#undo_last_action', :as => :undo_last_action, :via => :post
  match 'makebiz' => 'application#makebiz', :as => :makebiz
  match 'signin' => 'welcome#signin', :as => :signin
  match 'signup' => 'welcome#signup', :as => :signup
  match 'search_form' => 'welcome#search_form', :as => :search_form
  match 'mobile_filter/:category_id' => 'welcome#mobile_filter', :as => :mobile_filter
  match 'sms/:id' => 'welcome#sms', :as => :sms, :via => :post
  match 'leads' => 'welcome#leads', :as => :leads
  match '/:user_id' => 'welcome#index'
end
