class UserRole < ApplicationRecord
  belongs_to :user
  enum :role, [ :admin ]
end
