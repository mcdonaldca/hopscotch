class Hop < ActiveRecord::Base
	has_many :registrations
  has_many :users, through: :registrations
end
