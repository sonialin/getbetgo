Getbetgo::Application.routes.draw do

  resources :modification_requests

  resources :nominations

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  resources :proofs

  resources :replies

  resources :user_infos

  mount Resque::Server, :at => "/resque/:key", :constraints => {:key => ENV["RESQUE_KEY"]}

  get "about" => 'pages#about'
  get "giving" => 'pages#giving'
  get "receiving" => 'pages#receiving'
  get "howitworks" => 'pages#howitworks'
  get "termsofuse" => 'pages#termsofuse'
  get "privacystatement" => 'pages#privacystatement'
  get "faq" => 'pages#faq'
  get "comingsoon" => 'pages#comingsoon'
  get "aboutfundwok" => "pages#aboutfundwok"
  get "startafund" => "pages#startafund"
  get "applyforafund" => "pages#applyforafund"
  get "receiveafund" => "pages#receiveafund"
  get "directory" => "pages#directory"

  resources :relationships

  resources :paypal_recipient_accounts, :only => [:create, :destroy]
  get "fund_transfers/success"
  get "fund_transfers/failed"
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  get 'users/:identifier' => 'users#show', as: :user 
  get 'users/:identifier/followings' => 'users#followings', as: :followings
  get 'users/:identifier/followers' => 'users#followers', as: :followers
  
  resources :posts do
    post 'upvote', on: :member
    post 'publish', on: :member
    resources :bets do
      post 'select', on: :member
      post 'mark_complete', on: :member
      get 'receive', on: :member
    end
  end
  
  get 'bets/:id/payment' => 'bets#payment'
  get 'bets/:id/pay_process' => 'bets#pay_process'
  get 'transactions/:bet_id/success' => 'transactions#success'
  post 'transactions/:bet_id/success' => 'transactions#success'
  get 'transactions/:bet_id/failed' => 'transactions#failed'
  get 'tag/prediction' => 'tags#prediction'  
  get 'place/prediction' => 'places#prediction'  
  get 'orders/:token' => 'orders#show', as: :order 
  post 'paypal-ipn'  => 'transactions#paypal_ipn'

  post 'getposts' => 'posts#index'
  post 'getuserposts' => 'users#show'
  post 'getbets' => 'posts#getbets'

  root :to => 'posts#index'
  get 'tags/:tag', to: 'posts#index', as: :tag
  get 'category/:category', to: 'posts#index', as: :category
  get 'subcategory/:subcategory', to: 'posts#index', as: :subcategory, :constraints => {:subcategory => /.*/}
  get 'location/:location', to: 'posts#index', as: :location

  get 'posts/:post_id/bets/:id/receive' => 'bets#receive'

  mount Judge::Engine => '/judge'

  resources "contacts", only: [:new, :create]

  resources :notifications do
    post 'mark_read', on: :member
  end

  # get 'transactions/new' => 'transactions#new'
  # post 'transactions/create' => 'transactions#create'

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
