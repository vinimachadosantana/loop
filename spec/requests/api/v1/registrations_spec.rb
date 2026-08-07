require "rails_helper"

RSpec.describe "Api::V1::Registrations", type: :request do
  describe "POST /api/v1/registration" do
    it "creates a user" do
      expect {
        post "/api/v1/registration", params: {
          user: { email: "new@example.com", name: "John Doe", password: "password1234" }
        }
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json_body["user"]["email"]).to eq("new@example.com")
      expect(json_body["token"]).to be_present
    end

    it "never returns the password digest" do
      post "/api/v1/registration", params: {
        user: { email: "new@example.com", name: "John Doe", password: "password1234" }
      }

      expect(json_body).not_to have_key("password_digest")
    end

    it "returns a structured 422 for invalid input" do
      post "/api/v1/registration", params: { user: { email: "bad", name: "", password: "x" } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_body["error"]["code"]).to eq("validation_failed")
      expect(json_body["error"]["details"]).to have_key("email")
    end
  end
end
