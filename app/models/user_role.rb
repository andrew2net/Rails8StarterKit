class UserRole < ApplicationRecord
  belongs_to :user
  enum :role, { admin: 0 }
  validates :role, presence: true # , inclusion: { in: roles.keys }
end
