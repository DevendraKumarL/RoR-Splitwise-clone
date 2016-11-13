class Group < ApplicationRecord

	belongs_to :user
	has_many :bills
	has_and_belongs_to_many :unregist_users
	has_many :debts

end
