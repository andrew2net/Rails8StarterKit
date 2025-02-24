require 'rails_helper'

RSpec.describe UserRole, type: :model do
  describe "validations" do
    it "validates presence of role" do
      user_role = UserRole.new
      expect(user_role).not_to be_valid
      expect(user_role.errors[:role]).to include("can't be blank")
    end

    it "validates role is in roles" do
      user_role = UserRole.new(role: :super_admin)
      expect(user_role).not_to be_valid
      expect(user_role.errors[:role]).to include("is not included in the list")
    end
  end
end
