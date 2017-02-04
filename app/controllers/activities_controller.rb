class ActivitiesController < ApplicationController
	before_action :require_user, only: [:get_activities]
	protect_from_forgery

	layout "application", only: [:get_activities]

	def get_activities
		@title = "Activities | Splitwise"
		@user = User.find(session[:user_id])
		@user_groups = @user.groups
		@user_activities = @user.activities.order('created_at DESC')
	end

end
