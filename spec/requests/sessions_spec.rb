require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  fixtures :users
  let(:user) { users(:user) }

  describe "GET /session/new" do
    it "returns http success" do
      get new_session_path
      expect(response).to have_http_status(200)
      expect(response.body).to include("Sign in")
    end
  end

  describe "POST /session" do
    context "with valid credentials" do
      it "authenticates the user and redirects to root_url" do
        expect do
          post session_path, params: { email_address: user.email_address, password: "password" }
        end.to change { user.sessions.count }.by(1)
        expect(response).to redirect_to(root_url)
        expect(flash[:notice]).to eq("You have been signed in.")
      end
    end

    context "with invalid credentials" do
      it "redirects to new_session_path with an alert" do
        expect do
          post session_path, params: { email_address: user.email_address, password: 'wrong_password' }
        end.not_to change { user.sessions.count }
        expect(response).to redirect_to(new_session_path)
        expect(flash[:alert]).to eq("Try another email address or password.")
      end
    end
  end

  describe "DELETE /session" do
    it "terminates the session and redirects to root_path" do
      sign_in user
      expect { delete session_path }.to change { user.sessions.count }.by(-1)
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("You have been signed out.")
    end
  end
end
