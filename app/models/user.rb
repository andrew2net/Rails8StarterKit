class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :roles, dependent: :destroy, class_name: "UserRole"

  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }, on: :create

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def admin?
    roles.exists?(role: :admin)
  end
end
