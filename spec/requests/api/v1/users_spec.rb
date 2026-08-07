require "rails_helper"

RSpec.describe "Api::V1::Users", type: :request do
  describe "GET /api/v1/users/:id" do
    it "returns the user" do
      user = create(:user)

      get "/api/v1/users/#{user.id}"

      expect(response).to have_http_status(:ok)
      expect(json_body["id"]).to eq(user.id)
      expect(json_body["email"]).to eq(user.email)
    end

    it "returns a structured 404 for an unknown id" do
      get "/api/v1/users/999999"

      expect(response).to have_http_status(:not_found)
      expect(json_body["error"]["code"]).to eq("not_found")
    end
  end
end
