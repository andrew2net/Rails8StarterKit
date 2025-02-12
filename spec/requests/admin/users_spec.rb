require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  fixtures :users, :user_roles
  let(:admin) { users(:admin) }
  let(:user) { users(:user) }

  describe "GET /index" do
    it "returns http success" do
      sign_in admin
      get admin_users_path
      expect(response).to have_http_status(:success)
    end

    it "redirects to home#index and flashes an alert when action isn't authorized" do
      sign_in user
      get admin_users_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You are not authorized to perform this action.")
    end
  end

  describe "GET /show" do
    it "returns http success" do
      sign_in admin
      get admin_user_path(user)
      expect(response).to have_http_status(:success)
    end

    it "redirects to home#index and flashes an alert when action isn't authorized" do
      sign_in user
      get admin_user_path(user)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You are not authorized to perform this action.")
    end
  end

  describe "GET /new" do
    it "returns http success" do
      sign_in admin
      get new_admin_user_path
      expect(response).to have_http_status(:success)
    end

    it "redirects to home#index and flashes an alert when action isn't authorized" do
      sign_in user
      get new_admin_user_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You are not authorized to perform this action.")
    end
  end

  describe "POST /create" do
    it "send email with link to set password & redirects to the list of users" do
      sign_in admin
      expect do
        post admin_users_path, params: { user: { email_address: "new_user@example.com" } }
      end.to change(User, :count).by(1)
      expect(response).to redirect_to(admin_users_path)
    end
  end
end
