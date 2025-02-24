class UserRole < ApplicationRecord
  belongs_to :user
  enum :role, { admin: 0 }, validate: true
  validates :role, presence: true
end
