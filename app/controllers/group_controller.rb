class GroupController < ApplicationController
	before_action :require_user, only: [:get_group]
	protect_from_forgery

	layout "application", only: [:get_group]

	def get_group
		@group = Group.find(params[:group_id])
		@title = @group.name
		@user = User.find(session[:user_id])
		@user_groups = @user.groups
		@group_members = @group.unregist_users
		@group_bills = @group.bills

		@total_spent_in_this_group = 0
		@group_bills.each do |bill|
			@total_spent_in_this_group += bill.total_amount
		end
		member_debts = Debt.where(:member2 => @user.id, :group_id => @group.id)
							.where(['member1 <> ?', @user.id])
							.group(:member1).sum(:owes_amount)
		
		@group_members_debts = {}
		@group_members.each do |u|
			@group_members_debts[u.name] = (member_debts[u.id])
		end

		@total_user_spent_in_this_group = Debt.where(:group_id => @group.id, :member1 => @user.id)
											.sum(:owes_amount).round(2)

		@total_use_owes_from_this_group = Debt.where(:group_id => @group.id, :member2 => @user.id)
											.where(['member1 <> ?', @user.id]).sum(:owes_amount).round(2)
	end

	def create_group
		@title = "Dashboard | Splitwise"

		members = params[:member]
		member_emails = params[:member_email]

		if members.size != member_emails.size
			flash[:error_group] = "Member and Emails mismatch"
			render('dashboard')
		end

		group = Group.new
		group.name = params[:group_name]
		group.description = params[:group_description]
		group.user = User.find(session[:user_id])

		if group.save
			activity = Activity.new
			activity.activity_details = "You added group " + group.name
			activity.user = @user
			activity.save
			for i in 0..members.size-1
				if members[i] != ''
					unregist_user = UnregistUser.new
					unregist_user.name = members[i]
					unregist_user.email = member_emails[i]
					group.unregist_users << unregist_user
					a = Activity.new
					a.activity_details = "		Member " + unregist_user.name + " added to group " + group.name
					a.user = @user
					a.save
				end
			end
			flash[:notice] = "Group created Successfull"
			redirect_to :controller => 'home', :action => 'dashboard'
		else
			flash[:notice] = "Group couldn't be created"
			redirect_to :controller => 'home', :action => 'dashboard'
		end
	end

end
