class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  EMAIL_FORMAT = URI::MailTo::EMAIL_REGEXP
  MINIMUM_PASSWORD_LENGTH = 12

  before_validation :normalize_email

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_FORMAT }
  validates :name, presence: true, length: { maximum: 100 }
  validates :password, length: { minimum: MINIMUM_PASSWORD_LENGTH }, allow_nil: true

  private

  def normalize_email
    self.email = email.to_s.downcase.strip
  end
end
