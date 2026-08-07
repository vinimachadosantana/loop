class Session < ApplicationRecord
  belongs_to :user

  has_secure_token :token, length: 32

  scope :active, -> { where(created_at: 30.days.ago..) }

  def expired?
    created_at < 30.days.ago
  end
end
