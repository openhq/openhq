require 'rails_helper'

RSpec.feature "First time setup", type: :feature do
  context "when app is not setup" do
    scenario "redirects to /setup" do
      visit "/"
      expect(page).to have_content "Setup Open HQ"
    end

    context "when setting up" do
      scenario "sets up a user with role of owner" do
        visit "/"
        fill_in "user_first_name", :with => "John"
        fill_in "user_last_name", :with => "Connor"
        fill_in "user_username", :with => "admin"
        fill_in "user_email", :with => "john.connor@example.org"
        fill_in "user_password", :with => "Password1!"
        fill_in "user_password_confirmation", :with => "Password1!"
        click_button "Complete Setup"

        user = User.find_by(email: "john.connor@example.org")
        expect(user.role).to eq("owner")
      end
    end
  end
end
