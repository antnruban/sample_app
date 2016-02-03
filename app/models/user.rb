class User < ActiveRecord::Base

  VALID_EMAIL_REGEX = /\A[a-z\.\-\d]+@+[a-z]+.{1}+[a-z]+\z/x

  has_secure_password
  before_save { email.downcase! }
  before_create :confirmation_token
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: true }
  validates :password, length: { minimum: 6 }
  has_many  :microposts, dependent: :destroy
  has_many  :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many  :followed_users, through: :relationships, source: :followed
  has_many  :reverse_relationships, foreign_key: "followed_id",  class_name: "Relationship", dependent: :destroy
  has_many  :followers, through: :reverse_relationships, source: :follower

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end

  def access_token
    User.create_access_token(self)
  end

  def self.read_access_token(signature)
    id = verifier.verify(signature)
    User.find(id)
    rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end

  def unsubscribe_user
    self.update_attribute :email_subscribed, false
  end

  def send_password_reset
    self.update_attribute :password_reset_token, User.new_token
    self.update_attribute :password_reset_sent_at, Time.zone.now
    UserMailer.password_reset(self).deliver
  end

  private
#######################################################################################################################

  def confirmation_token
    self.confirm_token = User.new_token.to_s if self.confirm_token.blank?
  end

  def self.verifier
    ActiveSupport::MessageVerifier.new(SampleApp::Application.config.secret_key_base)
  end

  def self.create_access_token(user)
    verifier.generate(user.id)
  end
end
