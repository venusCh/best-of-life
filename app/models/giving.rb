class Giving < ActiveRecord::Base
	belongs_to :user
	has_many :asks, :dependent => :delete_all
	has_many :transfers, :dependent => :delete_all
	has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>", :original => "500x500" }, :default_url => "gift.jpg"
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	validates :name, :presence => true
	acts_as_votable
	acts_as_mappable :through => :user

end
