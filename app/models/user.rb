class User < ApplicationRecord

	has_secure_password

	has_many :groups
	has_many :activities
	
	validates :username, presence: true, uniqueness: true
	validates :email, presence: true, uniqueness: true
	validates :phone, presence: true, length: { minimum: 10, maximum:10 }, uniqueness: true
	validates :password, presence: true
	validates_confirmation_of :password
end
