require 'rails_helper'
require 'pundit/rspec'

RSpec.describe UserPolicy, type: :policy do
  fixtures :users, :user_roles
  let(:user) { users(:user) }
  let(:admin) { users(:admin) }

  subject { described_class }

  permissions ".scope" do
    context "when the user is an admin" do
      it "returns all users" do
        expect(UserPolicy::Scope.new(admin, User).resolve).to eq(User.all)
      end
    end

    context "when the user is not an admin" do
      it "returns only the current user" do
        expect(UserPolicy::Scope.new(user, User).resolve).to eq(User.where(id: user.id))
      end
    end

    context "when the user is not authenticated" do
      it "returns an empty relation" do
        expect(UserPolicy::Scope.new(nil, User).resolve).to eq(User.where(id: nil))
      end
    end
  end

  permissions :index? do
    context "when the user is an admin" do
      it "allows access" do
        expect(subject).to permit(admin, User)
      end
    end

    context "when the user is not an admin" do
      it "denies access" do
        expect(subject).not_to permit(user, User)
      end
    end

    context "when the user is not authenticated" do
      it "denies access" do
        expect(subject).not_to permit(nil, User)
      end
    end
  end

  permissions :show? do
    context "when the user is an admin" do
      it "allows access" do
        expect(subject).to permit(admin, user)
      end
    end

    context "when the user is not an admin" do
      it "allows access to the current user" do
        expect(subject).to permit(user, user)
      end

      it "denies access to other users" do
        expect(subject).not_to permit(user, admin)
      end
    end

    context "when the user is not authenticated" do
      it "denies access" do
        expect(subject).not_to permit(nil, user)
      end
    end
  end

  permissions :create? do
    context "when the user is an admin" do
      it "allows access" do
        expect(subject).to permit(admin, User)
      end
    end

    context "when the user is new" do
      it "allows access" do
        expect(subject).to permit(nil, User)
      end
    end

    context "when the user is not an admin" do
      it "denies access" do
        expect(subject).not_to permit(user, User)
      end
    end
  end

  permissions :update? do
    context "when the user is an admin" do
      it "allows access" do
        expect(subject).to permit(admin, user)
      end
    end

    context "when the user is not an admin" do
      it "allows access to the current user" do
        expect(subject).to permit(user, user)
      end

      it "denies access to other users" do
        expect(subject).not_to permit(user, admin)
      end
    end

    context "when the user is not authenticated" do
      it "denies access" do
        expect(subject).not_to permit(nil, user)
      end
    end
  end

  permissions :destroy? do
    context "when the user is an admin" do
      it "allows access" do
        expect(subject).to permit(admin, user)
      end
    end

    context "when the user is not an admin" do
      it "denies access" do
        expect(subject).not_to permit(user, user)
      end
    end

    context "when the user is not authenticated" do
      it "denies access" do
        expect(subject).not_to permit(nil, user)
      end
    end
  end
end
