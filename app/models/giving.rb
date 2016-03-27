class Giving < ActiveRecord::Base
	belongs_to :user
	has_many :asks, :dependent => :delete_all
	has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "gift.jpg"
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	validates :name, :presence => true
end
