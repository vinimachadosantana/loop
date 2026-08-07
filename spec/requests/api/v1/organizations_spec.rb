require "rails_helper"

RSpec.describe "Api::V1::Organizations", type: :request do
  let(:user) { create(:user) }

  describe "POST /api/v1/organizations" do
    it "creates the org and makes the creator an admin" do
      post "/api/v1/organizations",
           params: { organization: { name: "Acme Inc" } },
           headers: auth_headers_for(user)

      expect(response).to have_http_status(:created)
      expect(json_body["slug"]).to eq("acme-inc")
      expect(user.memberships.last).to be_admin
    end
  end

  describe "GET /api/v1/organizations" do
    it "returns only the organisations the user belongs to" do
      mine = create(:organization)
      create(:membership, user: user, organization: mine)
      create(:organization)

      get "/api/v1/organizations", headers: auth_headers_for(user)

      expect(json_body.map { |o| o["id"] }).to eq([ mine.id ])
    end
  end

  describe "cross-tenant access" do
    it "returns 404 for an organisation the user does not belong to" do
      other_org = create(:organization)

      get "/api/v1/organizations/#{other_org.id}", headers: auth_headers_for(user)

      expect(response).to have_http_status(:not_found)
    end
  end
end
