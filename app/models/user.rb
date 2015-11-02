class User < ActiveRecord::Base

  VALID_EMAIL_REGEX = /\A[a-z\.\d]+@+[a-z]+.{1}+[a-z]+\z/x

  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: true }
  has_secure_password
  validates :password, length: { minimum: 6 }
end
