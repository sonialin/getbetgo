Getbetgo::Application.routes.draw do
  

  resources :relationships

  # post "paypal_recipient_accounts/create"
  # delete "paypal_recipient_accounts/delete"

  resources :paypal_recipient_accounts, :only => [:create, :destroy]
  get "fund_transfers/success"
  get "fund_transfers/failed"
  devise_for :users
  resources :users, :only => [:show]
  
  resources :posts do
    resources :bets do
      post 'select', on: :member
      get 'receive', on: :member
      resources :updates, :only => [:create]
    end
  end
  get 'posts/:id/payment' => 'posts#payment'
  get 'posts/:id/pay_process' => 'posts#pay_process'
  get 'transactions/:post_id/success' => 'transactions#success'
  get 'transactions/:post_id/failed' => 'transactions#failed'

  root :to => 'posts#index'
  get 'tags/:tag', to: 'posts#index', as: :tag

  get 'posts/:post_id/bets/:id/receive' => 'bets#receive'
  get 'posts/:post_id/bets/:id/receive_process' => 'bets#receive_process'

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
