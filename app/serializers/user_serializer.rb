class UserSerializer
  include Alba::Resource

  attributes :id, :name, :email

  attribute :created_at do |user|
    user.created_at.iso8601
  end
end
