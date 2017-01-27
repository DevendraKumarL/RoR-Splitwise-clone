class UsersController < ApplicationController
	before_action :check_user, only: [:new]
	protect_from_forgery
	
	layout "application", only: [:new]

	def new
		@user = User.new
		@title = "Registration | Splitwise"
		@register = true
	end

	def create
		@user = User.new(user_params)

		if @user.save
			flash[:notice] = "Welcome! Registration Successfull, Login to continue"
			redirect_to :controller => 'sessions', :action => 'new'
		else
			# this is to preserve the form fields 
			# and other variables for the new action of this conroller
			@user = @user
			@title = "Registration | Splitwise"
			@register = true
			
			flash[:notice] = "Form is invalid"
			render :action => 'new'
		end
	end

	private
		def user_params
			params.require(:user).permit(
				:username, :email, :phone, :image, :password, :password_confirmation)
		end
end
