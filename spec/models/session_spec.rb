require "rails_helper"

RSpec.describe Session, type: :model do
  it { is_expected.to belong_to(:user) }

  it "generates a token on create" do
    session = create(:session)
    expect(session.token).to be_present
  end

  it "generates a unique token per session" do
    expect(create(:session).token).not_to eq(create(:session).token)
  end

  describe "#expired?" do
    it "is false for a fresh session" do
      expect(create(:session)).not_to be_expired
    end

    it "is true after 30 days" do
      session = create(:session)
      session.update_column(:created_at, 31.days.ago)
      expect(session.reload).to be_expired
    end
  end

  describe ".active" do
    it "excludes expired sessions" do
      fresh = create(:session)
      old = create(:session)
      old.update_column(:created_at, 31.days.ago)

      expect(Session.active).to include(fresh)
      expect(Session.active).not_to include(old)
    end
  end
end
