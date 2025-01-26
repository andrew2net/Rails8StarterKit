require 'rails_helper'
require 'pundit/rspec'

RSpec.describe Admin::DashboardPolicy, type: :policy do
  fixtures :users, :user_roles
  let(:user) { users(:user) }
  let(:admin) { users(:admin) }

  subject { described_class }

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :home? do
    context "when the user is an admin" do
      it "allows access" do
        expect(subject).to permit(admin)
      end
    end

    context "when the user is not an admin" do
      it "not allows access" do
        expect(subject).not_to permit(user)
      end
    end
  end
end
