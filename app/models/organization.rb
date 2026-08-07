class Organization < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  before_validation :generate_slug, on: :create

  validates :name, presence: true, length: { maximum: 100 }
  validates :slug, presence: true, uniqueness: true

  private

  def generate_slug
    self.slug = name.to_s.parameterize.presence
  end
end
