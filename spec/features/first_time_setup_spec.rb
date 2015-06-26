require 'rails_helper'

RSpec.feature "First time setup", type: :feature do
  context "when app is not setup" do
    scenario "redirects to /setup" do
      visit "/"
      expect(page).to have_content "Setup Open HQ"
    end
  end

  context "setting up owner" do
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

  context "complete setup page" do
    given!(:owner) { create(:user, role: "owner", password: "hunter212", password_confirmation: "hunter212") }
    given!(:std_user) { create(:user, role: "user", password: "hunter212", password_confirmation: "hunter212") }

    scenario "creates a project and invites team members" do
      sign_in_with owner.email, "hunter212"
      visit "/setup/complete"

      fill_in "initial_setup_form_project_name", with: "UI Design"
      fill_in "initial_setup_form_team_members", with: "jeff@example.org,john@example.org, sarah@example.org"
      click_button "Save"

      project = Project.first
      expect(project.users.pluck(:email)).to contain_exactly("jeff@example.org", "john@example.org", "sarah@example.org", owner.email)
    end

    scenario "is dissallowed for non owners" do
      sign_in_with std_user.email, "hunter212"
      visit "/setup/complete"

      expect(page).not_to have_content("Name your first project")
    end
  end
end
