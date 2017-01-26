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
		if params[:phone].length != 10
			flash[:notice] = "Phone must have 10 digits"
			render('signupPage')
			return
		end

		if params[:password] != params[:confirm_password]
			flash[:notice] = "Password & Confirm Password don\'t match"
			render('signupPage')
			return
		end

		@check = User.find_by_username(params[:username])
		if !@check.nil?
			flash[:notice] = "Username is already taken try something else"
			render('signupPage')
			return
		end

		@check = User.find_by_email(params[:email])
		if !@check.nil?
			flash[:notice] = "Email is already taken try something else"
			render('signupPage')
			return
		end

		@check = User.find_by_phone(params[:phone])
		if !@check.nil?
			flash[:notice] = "Phone is already taken try something else"
			render('signupPage')
			return
		end

		@user = User.new({
				:username => params[:username],
				:email => params[:email],
				:phone => params[:phone],
				:image => params[:image],
				:password => params[:password]
		})

		if @user.save
			flash[:notice] = "Welcome! Registration Successfull, Login to continue"
			redirect_to :controller => 'home', :action => 'loginPage', :notice => "Welcome! Registration Successfull, Login to continue"
		else
			flash[:notice] = "Form is invalid"
			render('signupPage')
			return
		end
	end
end
