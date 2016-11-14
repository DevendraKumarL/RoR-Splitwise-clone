class HomeController < ApplicationController

	protect_from_forgery

	layout 'navbar'

	$current_user = nil

	def homeIndex
		@title = "Splitwise"
		@register = nil
		@user = $current_user
	end

	def signupPage
		@title = "Registration | Splitwise"
		@register = true
		@user = $current_user
		if @user
			redirect_to dashboard_path
		end
	end

	def signupUser
		@title = "Registration | Splitwise"
		@register = true
		if params[:phone].length != 10
			flash[:error_register] = "Phone must have 10 digits"
			render('signupPage')
			return
		end

		if params[:password] != params[:confirm_password]
			flash[:error_register] = "Password & Confirm Password don\'t match"
			render('signupPage')
			return
		end

		@check = User.find_by_username(params[:username])
		if !@check.nil?
			flash[:error_register] = "Username is already taken try something else"
			render('signupPage')
			return
		end

		@check = User.find_by_email(params[:email])
		if !@check.nil?
			flash[:error_register] = "Email is already taken try something else"
			render('signupPage')
			return
		end

		@check = User.find_by_phone(params[:phone])
		if !@check.nil?
			flash[:error_register] = "Phone is already taken try something else"
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
			flash[:error_register] = "Form is invalid"
			render('signupPage')
			return
		end
	end

	def loginPage
		@title = "Login | Splitwise"
		@register = false
		@user = $current_user
		if @user
			redirect_to dashboard_path
		end
	end

	def loginUser
		@title = "Login | Splitwise"
		@register = false

		found_user = User.find_by_email(params[:email])
		if !found_user.nil?
			authenticated_user = found_user.authenticate(params[:password])
		end

		if !authenticated_user
			flash[:error_login] = "Invalid email/password, please try again"
			render('loginPage')
			return
		end

		session[:user_id] = authenticated_user
		$current_user = session[:user_id]
		flash[:notice] = "Login Successfull"
		redirect_to :controller => 'home', :action => 'dashboard', :notice => 'Login Successfull'
	end

	def logoutUser
		session[:user_id] = nil
		$current_user = nil
		flash[:notice] = "Logout Successfull"
		redirect_to :controller => 'home', :action => 'homeIndex', :notice => 'Logout Successfull'
	end

	def dashboard
		@title = "Dashboard | Splitwise"
		@user = $current_user
		if !@user
			redirect_to homeIndex_path
		end
		@user = User.find(@user.id)
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

	def group
		@group = Group.find(params[:group_id])
		@title = @group.name
		@user = $current_user
		if !@user
			redirect_to homeIndex_path
		end
		@user = User.find(@user.id)
		@user_groups = @user.groups
		@group_members = @group.unregist_users
		@group_bills = @group.bills

		@total_spent_in_this_group = 0
		@group_bills.each do |bill|
			@total_spent_in_this_group += bill.total_amount
		end
		member_debts = Debt.where(:member2 => @user.id, :group_id => @group.id).where(['member1 <> ?', @user.id])
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

	def createGroup
		@title = "Dashboard | Splitwise"
		@user = $current_user

		members = params[:member]
		member_emails = params[:member_email]

		if members.size != member_emails.size
			flash[:error_group] = "Member and Emails mismatch"
			render('dashboard')
		end

		group = Group.new
		group.name = params[:group_name]
		group.description = params[:group_description]
		group.user = User.find(@user.id)

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
			redirect_to :controller => 'home', :action => 'dashboard', :notice => 'Group created Successfull'
		else
			flash[:error_group] = "Group couldn\'t be created"
			render('dashboard')
		end
	end

	def createGroupBill
		@title = "Dashboard | Splitwise"
		@user = $current_user

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

	def bill
		@group = Group.find(params[:group_id])
		@bill = Bill.find(params[:bill_id])
		@title = @bill.name
		@user = $current_user
		if !@user
			redirect_to homeIndex_path
		end
		@user = User.find(@user.id)
		@user_groups = @user.groups
		bill_members = @bill.group.unregist_users
		
		members_debts = Debt.where(
			:bill_id => @bill.id, :group_id => @group.id).group(:member1).where(['member1 <> ?', @user.id]).sum(:owes_amount)
		@bill_members_debts = {}

		@total_bill_debt = 0
		bill_members.each do |m|
			@bill_members_debts[m.name] = (members_debts[m.id]).round(2)
			@total_bill_debt = @total_bill_debt + members_debts[m.id]
		end
		@total_bill_debt = @total_bill_debt.round(2)
		
		@user_paid = (@bill.total_amount - @total_bill_debt).round(2)
	end

	def activities
		@title = "Activities | Splitwise"
		@user = $current_user
		if !@user
			redirect_to homeIndex_path
		end
		@user = User.find(@user.id)
		@user_groups = @user.groups

		@user_activities = @user.activities.order('created_at DESC')
	end
end
