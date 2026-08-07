require "rails_helper"

RSpec.describe "Api::V1::Sessions", type: :request do
  let(:password) { "password1234" }
  let!(:user) { create(:user, password: password) }

  describe "POST /api/v1/session" do
    it "returns a token for valid credentials" do
      post "/api/v1/session", params: { session: { email: user.email, password: password } }

      expect(response).to have_http_status(:created)
      expect(json_body["token"]).to be_present
    end

    it "rejects a wrong password without revealing which field failed" do
      post "/api/v1/session", params: { session: { email: user.email, password: "wrong" } }

      expect(response).to have_http_status(:unauthorized)
      expect(json_body["error"]["message"]).to eq("Invalid email or password")
    end

    it "rejects an unknown email with the same message" do
      post "/api/v1/session", params: { session: { email: "nobody@example.com", password: password } }

      expect(json_body["error"]["message"]).to eq("Invalid email or password")
    end
  end

  describe "DELETE /api/v1/session" do
    it "revokes the session" do
      post "/api/v1/session", params: { session: { email: user.email, password: password } }
      token = json_body["token"]

      expect {
        delete "/api/v1/session", headers: { "Authorization" => "Bearer #{token}" }
      }.to change(Session, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end

  describe "authentication" do
    it "rejects requests without a token" do
      get "/api/v1/users/#{user.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    it "rejects a revoked token" do
      session = user.sessions.create!
      token = session.token
      session.destroy!

      get "/api/v1/users/#{user.id}", headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
