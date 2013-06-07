Codingdojo::Application.routes.draw do

 get "recruiter_view/create"

 resources :students, :recruiters
 resources :sessions, :only => [:new, :create, :request_password, :change_password, :update_password, :destroy]

 match "/signin",  :to => 'sessions#new'
 match "/renewal",  :to => 'sessions#request_password'
 match "/update_password",  :to => 'sessions#update_password'
 match "/change_password/:id", :to => 'sessions#change_password'
 match "/signout", :to => 'sessions#destroy'

 match "/terms_and_conditions", :to => 'recruiters#display_terms'

#This display_resume route is intended for development only since only resume are only stored in local storage
 match "/resume/:id", :as => 'resume',:to => 'students#display_resume'

 match "/terms",  :to => 'recruiters#term_approval'

 match "/leads",  :to => 'recruiters#request_leads'


 match "/recruiter_view/:id/:status",  :to => 'recruiters#update_view', :as => 'recruiter_view'

 match '/recruiters/:id/:filter', :as => 'recruiter_filter', :controller => 'recruiters', :action => 'show', :conditions => { :method => :get }

 match '/recruiter/student/:id', :as => 'send_email_to_student', :controller => 'recruiters', :action => 'get_introduce'

 
 match '/recruiter/candidate/:id', :as => 'add_to_short_list', :controller => 'recruiters', :action => 'save_to_short_list'

 match '/recruiter/candidate/remove/:id', :as => 'remove_from_short_list', :controller => 'recruiters', :action => 'remove_from_short_list'

 match '/belt/filters', :controller => 'students', :action => 'save_filter'

 root :to => 'sessions#new'

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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
