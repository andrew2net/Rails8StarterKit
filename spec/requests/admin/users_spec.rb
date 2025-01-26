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
end
