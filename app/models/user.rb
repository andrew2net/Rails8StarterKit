class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :roles, dependent: :destroy, class_name: "UserRole"

  validates :email_address, presence: true, uniqueness: true

  # pasword blank is validated by has_secure_password
  validates :password, length: { minimum: 8 }, on: :create, unless: :skip_password_validation?

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def admin?
    roles.exists?(role: :admin)
  end

  def self.invite(email)
    user = new(email_address: email)
    if user.save_without_password_validation
      UserMailer.with(user: user).invite.deliver_later
    end
    user
  end

  def valid_without_password?
    @skip_password_validation = true
    valid?
  ensure
    @skip_password_validation = false
  end

  def save_without_password_validation
    @skip_password_validation = true
    save
  ensure
    @skip_password_validation = false
  end

  def errors
    super.tap do |errors|
      errors.delete(:password, :blank) if skip_password_validation?
    end
  end

  def update_roles(roles)
    self.roles = roles.reject(&:empty?).map { |r| UserRole.new(role: r) }
    true
  rescue ArgumentError => e
    self.errors.add(:roles, e.message)
    false
  end

  private

  def skip_password_validation?
    @skip_password_validation
  end
end
