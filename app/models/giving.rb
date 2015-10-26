class Giving < ActiveRecord::Base
	belongs_to :user
	has_many :asks
end
