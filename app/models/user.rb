class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
    		:recoverable, :rememberable, :trackable, :validatable
	has_many :givings
	acts_as_messageable

  	has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "user-avatar.jpg"
  	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

	def mailboxer_email(object)
		return email
	end

	def name
		return "#{first_name} #{last_name}"
	end
end
