require "rails_helper"

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to have_secure_password }

  it "downcases and strips the email before validation" do
    user = create(:user, email: "  MiXeD@Example.COM ")
    expect(user.email).to eq("mixed@example.com")
  end

  it "rejects a malformed email" do
    expect(build(:user, email: "not-an-email")).not_to be_valid
  end

  it "rejects a short password" do
    expect(build(:user, password: "short")).not_to be_valid
  end

  it "authenticates with the correct password" do
    user = create(:user, password: "password1234")
    expect(user.authenticate("password1234")).to eq(user)
    expect(user.authenticate("wrong")).to be false
  end
end
