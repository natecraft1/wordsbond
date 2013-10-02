class User < ActiveRecord::Base
	has_many :years
	has_many :relationships, dependent: :destroy, foreign_key: :follower_id
  has_many :followed_users, through: :relationships, source: :followed


	before_save { self.email = email.downcase }
  before_create :create_remember_token
	validates :name, presence: true, length: {minimum: 3, maximum: 25}, allow_blank: false, uniqueness: true
  validates_format_of :name, :with => /^[^0-9`!@#\$%\^&*+_=]+$/, :multiline => true
	validates :email, presence: true, uniqueness: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create

	has_secure_password
	validates :password, length: { minimum: 6, maximum: 20 }
	validates :password, :confirmation => true
	validates :date_of_birth, presence: true

	
	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
	end

	def following?(followed)
		relationships.find_by_followed_id(followed)
	end

	def follow!(followed)
		relationships.create!(:followed_id => followed.id)
	end

	def age
    age ||= datenow > self.dateborn ? yearnow - self.yearborn : yearnow - self.yearborn - 1
  end

  def ageray
    ageray ||= (0..age).to_a.reverse
  end

	def yearnow
    yearnow ||= Time.now.strftime("%Y/%m/%d").gsub('/', '').scan(/..../)[0].to_i
	end
	
	def datenow
    datenow ||= Time.now.strftime("%Y/%m/%d").gsub('/', '').scan(/..../)[1].to_i
	end

	def yearborn
    yearborn ||= self.date_of_birth.to_s.gsub('-', '').scan(/..../)[0].to_i
	end
	
	def dateborn
    dateborn ||= self.date_of_birth.to_s.gsub('-', '').scan(/..../)[1].to_i
	end

	private
		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end

end
