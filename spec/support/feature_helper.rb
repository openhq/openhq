module FeatureHelper
  def sign_in_with(email, password)
    sign_out

    visit "/sign_in"
    fill_in "session_email", with: email
    fill_in "session_password", with: password
    click_button "Sign in"
  end

  def sign_out
    Capybara.reset_session!
  end
end

RSpec.configure do |config|
  config.include FeatureHelper, type: :feature
end
