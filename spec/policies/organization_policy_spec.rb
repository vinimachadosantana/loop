require "rails_helper"

RSpec.describe OrganizationPolicy do
  subject { described_class.new(user, organization) }

  let(:organization) { create(:organization) }

  context "when the user is an admin" do
    let(:user) { create(:user) }
    before { create(:membership, user: user, organization: organization, role: :admin) }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:update) }
  end

  context "when the user is a plain member" do
    let(:user) { create(:user) }
    before { create(:membership, user: user, organization: organization, role: :member) }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_action(:update) }
  end

  context "when the user is not a member" do
    let(:user) { create(:user) }

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:update) }
  end
end
