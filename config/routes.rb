Rails.application.routes.draw do

	root 'home#home_index'

	# registration routes
	get 'signup' => 'users#new', :as => :signupPage
	post 'signup-user' => 'users#create', :as => :signupUser
	# ^ same as below 
	# get 'register/signup' => 'home#signupPage', :as => :signupPage
	# post 'register/signup-user' => 'home#signupUser', :as => :signupUser
	
	# authentication routes
	get 'login' => 'sessions#new', :as => :loginPage
	post 'login' => 'sessions#create', :as => :loginUser
	delete 'logout' => 'sessions#destroy', :as => "logoutUser"

	# home route
	get 'home/index' => 'home#home_index', :as => :homeIndex

	# dashboard
	get 'dashboard' => 'home#dashboard', :as => :dashboard

	# groups routes
	get 'group/:group_id' => 'group#get_group', :as => :group
	post 'create-group' => 'home#create_group', :as => "createGroup"
	# post 'create-group' => 'group#create_group', :as => :createGroup

	# bills routes
	get 'group/:group_id/bill/:bill_id' => 'bill#get_bill', :as => :bill
	post 'group/create-bill' => 'home#create_group_bill', :as => :createGroupBill

	# activity routes
	get 'activities' => 'activities#get_activities', :as => :activities


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
