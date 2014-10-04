class User < ActiveRecord::Base
	validates :username, :presence => true, :uniqueness => true
  validates :email, :presence => true, :uniqueness => true
  validates :password, :presence => true, :confirmation => true
  validates :first, :presence => true
  validates :last, :presence => true
  validates :phone, :presence => true
end
