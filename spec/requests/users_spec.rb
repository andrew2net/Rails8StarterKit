require 'rails_helper'

RSpec.describe "Users", type: :request do
  fixtures :users
  let(:user) { users(:user) }

  describe "GET /new" do
    it "returns http success" do
      get new_user_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      sign_in user
      get user_path
      expect(response).to have_http_status(:success)
    end

    it "redirects to the sign-in page if not authenticated" do
      get user_path
      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      sign_in user
      get edit_user_path
      expect(response).to have_http_status(:success)
    end

    it "redirects to the sign-in page if not authenticated" do
      get edit_user_path
      expect(response).to redirect_to(new_session_path)
    end
  end
end
