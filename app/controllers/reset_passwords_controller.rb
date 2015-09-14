class ResetPasswordsController < Clearance::PasswordsController
  def deliver_email(user)
    UserMailer.change_password(user).deliver_later
  end
end
