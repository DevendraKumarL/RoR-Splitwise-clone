class SessionsController < ApplicationController
	before_action :check_user, only: [:new]
	protect_from_forgery
	
	layout "application", only: [:new]

	def new
		@title = "Login | Splitwise"
		@register = false
	end

	def create
		user = User.find_by_email(params[:session][:email])
		if user and user.authenticate(params[:session][:password])
			session[:user_id] = user.id
			flash[:notice] = "Login Successfull"
			redirect_to :controller => 'home', :action => 'dashboard'
		else
			flash[:notice] = "Invalid email/password, please try again"
			redirect_to '/login'
		end
	end

	def destroy
		session[:user_id] = nil
		flash[:notice] = "Logout Successfull"
		redirect_to :controller => 'home', :action => 'homeIndex'
	end
end
