class User < ActiveRecord::Base

  VALID_EMAIL_REGEX = /\A[a-z\.\-\d]+@+[a-z]+.{1}+[a-z]+\z/x

  has_secure_password
  before_save { email.downcase! }
  before_create :create_remember_token
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: true }
  validates :password, length: { minimum: 6 }
  has_many  :microposts, dependent: :destroy
  has_many :relationships,foreign_key: "follower_id", dependent: :destroy

  def feed
    Micropost.where("user_id = ?", id)
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
#######################################################################################################################

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end
