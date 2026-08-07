class User < ApplicationRecord
  EMAIL_FORMAT = URI::MailTo::EMAIL_REGEXP

  before_validation :normalize_email

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_FORMAT }
  validates :name, presence: true, length: { maximum: 100 }

  private

  def normalize_email
    self.email = email.to_s.downcase.strip
  end
end
