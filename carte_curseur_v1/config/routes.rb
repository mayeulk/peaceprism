ActionController::Routing::Routes.draw do |map|
  map.connect 'datasets/import_all_edf', :controller => 'datasets', :action => 'import_all_edf'
  map.resources :variables
  map.resources :var_labels
  map.connect 'var_label/:dataset_id/:variable_id/:value', :controller => 'var_label',
    :action => 'show_description'
  map.connect 'variable/:dataset_id/:variable_id', :controller => 'variables',
    :action => 'show_description'

  map.resources :datasets
  map.connect 'data/:dataset_id', :controller => 'data', :action => 'show_dataset'
  map.connect 'data/:dataset_id/col/:variable_id', :controller => 'data', :action => 'show_column'
  
  map.connect 'graph/dis/:dataset_id/:variable_id', :controller => 'graph', :action => 'dis'
  
  map.connect 'data/:dataset_id/row/:row_id', :controller => 'data', :action => 'show_row'
  map.connect 'data/:dataset_id/:variable_id/:row_id', :controller => 'data', :action => 'show_value'
  
  map.connect 'graph/:nb', :controller => 'graph', :action => 'png'
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

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

