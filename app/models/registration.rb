class Registration < ActiveRecord::Base
	belongs_to :user
	belongs_to :hop
	has_many :locations
end
