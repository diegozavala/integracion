Integra2::Application.routes.draw do

  resources :offers

  # This line mounts Spree's routes at the root of your application.
  # This means, any features to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
        

  resources :dashboards

  resources :clientes

  resources :api_users

  resources :productos

  resources :pedidos

  resources :ftp_pedidos

  resources :homes


  ##### Inicio API #####
  post 'api/pedirProducto' => 'api#pedir_productos'
  #####  Fin API   #####

  get 'create_prod' =>'homes#create_prod', as: 'create_prod'
  

  #Gestion de stocks
  post 'gestion_de_stocks/almacenes' => 'stock#post', as: 'stock_post'
  get 'gestion_de_stocks/almacenes' => 'stock#almacenes', as: 'stock_almacenes'
  get 'gestion_de_stocks/almacenes/:almacen' => 'stock#almacen', as: 'stock_almacen'
  get 'gestion_de_stocks/almacenes/:almacen/sku/:sku' => 'stock#products', as: 'stock_products'

  # This line mounts Spree's routes at the root of your application.
  # This means, any features to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, :at => '/store'
          # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
root :to => "homes#index"
get 'dropbox' => 'homes#dropbox'
get 'test_ftp' => 'homes#test_ftp', as 'test_ftp'


  #DROPBOX
  get 'tweet'=> 'homes#tweet'
  get 'rabbit' => 'homes#rabbit'
  #  # Example resource route (maps HTTP verbs to controller actions automatically):
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
