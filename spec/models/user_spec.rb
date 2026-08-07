require "rails_helper"

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  it "downcases and strips the email before validation" do
    user = create(:user, email: "  MiXeD@Example.COM ")
    expect(user.email).to eq("mixed@example.com")
  end

  it "rejects a malformed email" do
    expect(build(:user, email: "not-an-email")).not_to be_valid
  end
end
