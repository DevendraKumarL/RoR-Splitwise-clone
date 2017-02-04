Rails.application.routes.draw do

	# registration routes
	get 'signup' => 'users#new', :as => :signupPage
	post 'signup-user' => 'users#create', :as => :signupUser
	# ^ same as below 
	# get 'register/signup' => 'home#signupPage', :as => :signupPage
	# post 'register/signup-user' => 'home#signupUser', :as => :signupUser
	
	# authentication routes
	get 'login' => 'sessions#new'
	post 'login' => 'sessions#create'
	delete 'logout' => 'sessions#destroy'
	# ^ same as below 
	# get 'authentication/login'  => 'home#loginPage', :as => :loginPage
	# post 'authentication/login-user' => 'home#loginUser', :as => :loginUser 
	# get 'authentication/logout' => 'home#logoutUser', :as => :logoutUser

	# home route
	get 'home/index' => 'home#homeIndex', :as => :homeIndex

	# dashboard
	get 'dashboard' => 'home#dashboard', :as => :dashboard

	# groups routes
	get 'group/:group_id' => 'group#get_group', :as => :group
	post 'create-group' => 'group#create_group', :as => :createGroup

	# bills routes
	get 'group/:group_id/bill/:bill_id' => 'bill#get_bill', :as => :bill
	post 'group/create-bill' => 'home#createGroupBill', :as => :createGroupBill

	# activity routes
	get 'activities' => 'activities#get_activities', :as => :activities
	# get 'activities' => 'home#activities', :as => :activities


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
