Rails.application.routes.draw do

	# registration routes
	get 'register/signup' => 'home#signupPage', :as => :signupPage
	post 'register/signup-user' => 'home#signupUser', :as => :signupUser
	
	# authentication routes
	get 'authentication/login'  => 'home#loginPage', :as => :loginPage
	post 'authentication/login-user' => 'home#loginUser', :as => :loginUser 
	get 'authentication/logout' => 'home#logoutUser', :as => :logoutUser

	# home route
	get 'home/index' => 'home#homeIndex', :as => :homeIndex

	# dashboard
	get 'dashboard' => 'home#dashboard', :as => :dashboard

	# groups routes
	get 'user/group/:group_id' => 'home#group', :as => :group
	post 'user/create-group' => 'home#createGroup', :as => :createGroup

	# bills routes
	get 'user/group/:group_id/bill/:bill_id' => 'home#bill', :as => :bill
	post 'user/group/create-bill' => 'home#createGroupBill', :as => :createGroupBill

	# activity routes
	get 'activities' => 'home#activities', :as => :activities

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
