class BillController < ApplicationController
	before_action :require_user, only: [:get_bill]
	protect_from_forgery

	layout "application", only: [:get_bill]

	def get_bill
		@group = Group.find(params[:group_id])
		@bill = Bill.find(params[:bill_id])
		@title = @bill.name
		@user = User.find(session[:user_id])
		@user_groups = @user.groups
		bill_members = @bill.group.unregist_users
		
		members_debts = Debt.where(:bill_id => @bill.id, :group_id => @group.id)
						.group(:member1).where(['member1 <> ?', @user.id]).sum(:owes_amount)
		@bill_members_debts = {}

		@total_bill_debt = 0
		bill_members.each do |m|
			@bill_members_debts[m.name] = (members_debts[m.id]).round(2)
			@total_bill_debt = @total_bill_debt + members_debts[m.id]
		end
		@total_bill_debt = @total_bill_debt.round(2)
		
		@user_paid = (@bill.total_amount - @total_bill_debt).round(2)
	end
end
