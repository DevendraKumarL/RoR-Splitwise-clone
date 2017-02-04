class HomeController < ApplicationController
	before_action :require_user, only: [:dashboard, :activities, :group]
	protect_from_forgery

	layout "application", only: [:homeIndex, :dashboard]

	def home_index
		@title = "Splitwise"
		@register = nil
	end

	def dashboard
		@title = "Dashboard | Splitwise"
		@user = User.find(session[:user_id])
		@user_groups = @user.groups
		user_debts = Debt.where(:member2 => @user.id).where(['member1 <> ?', @user.id]).group(:member1).sum(:owes_amount)
		user_friends = UnregistUser.where(:id => user_debts.keys)
		@friends = {}
		user_friends.each do |u|
			@friends[u.name] = (user_debts[u.id]).round(2)
		end
		@total_user_spent = Debt.where(:member1 => @user.id).sum(:owes_amount).round(2)
		@total_user_owed = Debt.where(['member1 <> ? AND member2 = ?', @user.id, @user.id]).sum(:owes_amount).round(2)
		@total_user_owes = 0
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
		group.user = current_user

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
			flash[:notice] = "Group couldn\'t be created"
			redirect_to :controller => 'home', :action => 'dashboard'
		end
	end

	def create_group_bill
		@title = "Dashboard | Splitwise"
		@user = User.find(session[:user_id])

		group = Group.find(params[:group_id])
		bill = Bill.new
		bill.name = params[:bill_name]
		bill.descrption = params[:bill_description]
		bill.total_amount = params[:total_amount]
		bill.split_method = params[:split_method]
		bill.group = group

		if group.bills << bill
			activity = Activity.new
			activity.activity_details = "	Bill " + bill.name + " added to group " + group.name
			activity.user = @user
			activity.save

			total_amount = bill.total_amount
			split_method = bill.split_method
			no_of_users = group.unregist_users.size + 1 # the admin of group
			unregist_users_by_shares = params[:unregist_user_id_share]
			unregist_users_by_per = params[:unregist_user_id_per]
			regist_user_by_share = params[:regist_user_id_share]
			regist_user_by_per = params[:regist_user_by_per]

			if split_method == "Split Equally"
				individual_amt = total_amount / no_of_users.to_f
				individual_amt = individual_amt.round(2)
				
				group.unregist_users.each do |unregist_u|
					debt = Debt.new
					debt.member1 = unregist_u.id
					debt.member2 = @user.id
					debt.owes_amount = individual_amt
					debt.unregist_mem1 = true
					debt.unregist_mem2 = false
					debt.group = group
					debt.bill = bill

					if !debt.save
						flash[:notice] = "Bill creation fail"
						render 'group', :group_id => group.id
						return
					end
				end
				# user debt
				debt = Debt.new
				debt.member1 = @user.id
				debt.member2 = @user.id
				debt.owes_amount = individual_amt
				debt.unregist_mem1 = false
				debt.unregist_mem2 = false
				debt.group = group
				debt.bill = bill

				# might not store then, the whole thing is wrong
				# fix it later
				if !debt.save
					flash[:notice] = "Bill creation fail"
					render 'group', :group_id => group.id
					return
				end

				flash[:notice] = "Bill creation Successfull"
				redirect_to :contoller => 'home', :action => :group, :group_id => group.id, :notice => "Bill creation Successfull"
				return

			elsif split_method == "Split By Shares"
				inputShares = params["split-share"]
				shares = []
				totalShares = 0
				for i in 0..no_of_users-1
					shares[i] = inputShares[i].to_i
					totalShares += shares[i]
				end

				actualIndividualAmt = total_amount / totalShares.to_f;
				actualIndividualAmt = actualIndividualAmt.round(2);

				finalIndividualShares = []
				for i in 0..no_of_users-1
					finalIndividualShares[i] = shares[i] * actualIndividualAmt
				end

				for i in 0..no_of_users-2
					debt = Debt.new
					debt.member1 = unregist_users_by_shares[i].to_i
					debt.member2 = @user.id
					debt.owes_amount = finalIndividualShares[i]
					debt.unregist_mem1 = true
					debt.unregist_mem2 = false
					debt.group = group
					debt.bill = bill

					if !debt.save
						flash[:notice] = "Bill creation fail"
						render 'group', :group_id => group.id
						return
					end
				end
				# user debt
				debt = Debt.new
				debt.member1 = @user.id
				debt.member2 = @user.id
				debt.owes_amount = finalIndividualShares[finalIndividualShares.size-1]
				debt.unregist_mem1 = false
				debt.unregist_mem2 = false
				debt.group = group
				debt.bill = bill

				# might not store then, the whole thing is wrong
				# fix it later
				if !debt.save
					flash[:notice] = "Bill creation fail"
					render 'group', :group_id => group.id
					return
				end

				flash[:notice] = "Bill creation Successfull"
				redirect_to :contoller => 'home', :action => :group, :group_id => group.id, :notice => "Bill creation Successfull"
				return

			elsif split_method == "Split By %"
				inputPers = params["split-per"]
				pers = []
				totalPers = 0
				for i in 0..no_of_users-1
					shares[i] = inputPers[i].to_i
					totalPers += shares[i]
				end

				left = 100 - totalPers

				if left < 0 || left > 0
					flash[:error_group] = "Something wrong with the split"
					render('group')
					return
				end

				finalIndividualShares = []

				for i in 0..no_of_users-1
					finalIndividualShares[i] = (( (pers[i] * total_amount) / 100.0 ).round(2))
				end

				for i in 0..no_of_users-2
					debt = Debt.new
					debt.member1 = unregist_users_by_per[i].to_i
					debt.member2 = @user.id
					debt.owes_amount = finalIndividualShares[i]
					debt.unregist_mem1 = true
					debt.unregist_mem2 = false
					debt.group = group
					debt.bill = bill

					if !debt.save
						flash[:notice] = "Bill creation fail"
						render 'group', :group_id => group.id
						return
					end
				end
				# user debt
				debt = Debt.new
				debt.member1 = @user.id
				debt.member2 = @user.id
				debt.owes_amount = finalIndividualShares[finalIndividualShares.size-1]
				debt.unregist_mem1 = false
				debt.unregist_mem2 = false
				debt.group = group
				debt.bill = bill

				# might not store then, the whole thing is wrong
				# fix it later
				if !debt.save
					flash[:notice] = "Bill creation fail"
					render 'group', :group_id => group.id
					return
				end

				flash[:notice] = "Bill creation Successfull"
				redirect_to :contoller => 'home', :action => :group, :group_id => group.id, :notice => "Bill creation Successfull"
				return
			end
		else
			flash[:error_group] = "Something wrong with the bill"
			render('group')
			return
		end
	end

end
