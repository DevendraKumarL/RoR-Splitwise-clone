class Bill < ApplicationRecord

	belongs_to :group
	has_many :debts

end
