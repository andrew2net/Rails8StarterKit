class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail subject: "Reset your password", to: user.email_address
  end

  def invite(user)
    @user = user
    mail subject: "You're invited to join the team", to: user.email_address
  end
end
