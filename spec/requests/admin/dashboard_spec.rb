require 'rails_helper'

RSpec.describe "Admin::Dashboard", type: :request do
  fixtures :users, :user_roles
  let(:admin) { users(:admin) }
  let(:user) { users(:user) }

  describe "GET /home" do
    it "returns http success" do
      sign_in admin
      get admin_path
      expect(response).to have_http_status(:success)
    end

    it "redirects to the sign-in page if not authenticated" do
      get admin_path
      expect(response).to redirect_to(new_session_path)
    end

    it "redirect to home page and show a flash message if not authorized" do
      sign_in user
      get admin_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You are not authorized to perform this action.")
    end
  end
end
