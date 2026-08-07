FactoryBot.define do
  factory :session do
    user { nil }
    token { "MyString" }
    ip_address { "MyString" }
    user_agent { "MyString" }
  end
end
