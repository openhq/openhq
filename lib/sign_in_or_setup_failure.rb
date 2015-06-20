class SignInOrSetupFailure < Devise::FailureApp
  def redirect_url
    if User.any?
      new_user_session_url
    else
      setup_path
    end
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
