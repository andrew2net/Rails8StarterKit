require 'rails_helper'

RSpec.describe User, type: :model do
  let (:valid_user) { User.create(email_address: "user@example.com", password: "password") }

  it "validates the presence of an email address" do
    user = User.new(password: "password")
    expect(user).not_to be_valid
    expect(user.errors[:email_address]).to include("can't be blank")
  end

  it "validates the presence of a password" do
    user = User.new(email_address: "user@example.com")
    expect(user).not_to be_valid
    expect(user.errors[:password]).to include("can't be blank")
  end

  it "validates the uniqueness of an email address" do
    User.create!(email_address: "user@example.com", password: "password")
    expect(valid_user).not_to be_valid
    expect(valid_user.errors[:email_address]).to include("has already been taken")
  end

  it "normalizes the email address" do
    user = User.create!(email_address: "User@EXAMPLE.com", password: "password")
    expect(user.email_address).to eq("user@example.com")
  end

  it "validates the length of a password" do
    user = User.new(email_address: "user@example.com", password: "pass")
    expect(user).not_to be_valid
    expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
  end

  it "creates a new user" do
    expect(valid_user).to be_valid
  end

  it "roles are empty by default" do
    expect(valid_user.roles).to be_empty
  end

  it "is not an admin by default" do
    expect(valid_user).not_to be_admin
  end

  it "is an admin if it has the admin role" do
    valid_user.roles.create!(role: :admin)
    expect(valid_user).to be_admin
  end

  it "session is empty by default" do
    expect(valid_user.sessions).to be_empty
  end

  it "creates a new session" do
    valid_user.sessions.create!
    expect(valid_user.sessions).not_to be_empty
  end
end
