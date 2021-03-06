class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable, :omniauthable,
    		:recoverable, :rememberable, :trackable, :validatable
	has_many :givings
	has_many :comments
	acts_as_messageable
	acts_as_votable
	acts_as_voter
	validates :zip, :numericality => {:only_integer => true}, :allow_nil => true

  	has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "user-avatar.jpg"
  	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

	def mailboxer_email(object)
		return email
	end

	def name
		return "#{first_name} #{last_name}"
	end

	def self.from_omniauth(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.email = auth.info.email
			user.first_name = auth.info.first_name
			user.last_name = auth.info.last_name
			user.avatar = auth.info.image
		end
	end

	def self.new_with_session(params, session)
		if session["devise.user_attributes"]
			new(session["devise.user_attributes"], without_protection: true) do |user|
				user.attributes = params
				user.valid?
			end
		else
			super
		end
	end

	def password_required?
		super && provider.blank?
	end

end
