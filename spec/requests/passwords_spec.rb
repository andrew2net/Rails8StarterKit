require 'rails_helper'

RSpec.describe "Passwords", type: :request do
  fixtures :users
  let(:user) { users(:user) }

  describe "GET /passwords/new" do
    it "works! (now write some real specs)" do
      get new_password_path
      expect(response).to have_http_status(200)
      expect(response.body).to include("Forgot your password?")
    end
  end

  describe "POST /passwords" do
    context "with an existing user" do
      it "sends a password reset email" do
        expect do
          perform_enqueued_jobs do
            post passwords_path, params: { email_address: user.email_address }
          end
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
        expect(response).to redirect_to(new_session_path)
        expect(flash[:notice]).to eq("Password reset instructions sent (if user with that email address exists).")
      end
    end

    context "with a non-existing user" do
      it "does not send a password reset email" do
        expect do
          perform_enqueued_jobs do
            post passwords_path, params: { email_address: "" }
          end
        end.not_to change { ActionMailer::Base.deliveries.count }
        expect(response).to redirect_to(new_session_path)
        expect(flash[:notice]).to eq("Password reset instructions sent (if user with that email address exists).")
      end
    end
  end

  describe "GET /passwords/:token/edit" do
    context "with a valid token" do
      it "returns http success" do
        get edit_password_path(user.password_reset_token)
        expect(response).to have_http_status(200)
        expect(response.body).to include("Update your password")
      end
    end

    context "with an invalid token" do
      it "redirects to new_password_path with an alert" do
        get edit_password_path("invalid_token")
        expect(response).to redirect_to(new_password_path)
        expect(flash[:alert]).to eq("Password reset link is invalid or has expired.")
      end
    end
  end

  describe "PATCH /passwords/:token" do
    let(:token) { user.password_reset_token }

    it "updates the password" do
      expect do
        patch password_path(token), params: { password: "new_password", password_confirmation: "new_password" }
      end.to change { user.reload.password_digest }
      expect(response).to redirect_to(new_session_path)
      expect(flash[:notice]).to eq("Password has been reset.")
      expect(user.authenticate("new_password")).to eq(user)
    end

    it "does not update the password with invalid data" do
      expect do
        patch password_path(token), params: { password: "new_password", password_confirmation: "wrong" }
      end.not_to change { user.reload.password_digest }
      expect(response).to redirect_to(edit_password_url(token))
      expect(flash[:alert]).to eq("Passwords did not match.")
    end

    it "redirects to new_password_path with an alert for an invalid token" do
      expect do
        patch password_path("invalid_token"), params: { password: "new_password", password_confirmation: "new_password" }
      end.not_to change { user.reload.password_digest }
      expect(response).to redirect_to(new_password_path)
      expect(flash[:alert]).to eq("Password reset link is invalid or has expired.")
    end
  end
end
