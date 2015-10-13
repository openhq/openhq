require 'rails_helper'

RSpec.feature "First user setup", type: :feature do
  include ActiveJob::TestHelper

  given!(:team) { create(:team) }

  context "when single site install" do
    context "when users exist" do
      given!(:user) { create(:user) }
      given!(:team_user) { create(:team_user, user: user, team: team) }

      scenario "doesn’t allow access" do
        visit "/setup"
        expect(page).not_to have_content "Setup your account"
      end
    end

    context "when no users exist yet" do
      scenario "shows the first time setup form" do
        visit "/"
        expect(page).to have_content "Setup your account"
      end

      scenario "completes the account setup flow" do
        perform_enqueued_jobs do
          # User signup
          visit "/"
          fill_in "user_first_name", :with => "John"
          fill_in "user_last_name", :with => "Connor"
          fill_in "user_username", :with => "admin"
          fill_in "user_email", :with => "john.connor@example.org"
          fill_in "user_password", :with => "Password1!"
          click_button "Save changes"

          user = User.find_by(email: "john.connor@example.org")
          expect(user.team_users.first.role).to eq("owner")

          # Project creation
          expect(page).to have_content "Create your first project"
          fill_in "project_name", :with => "Games dev"
          click_button "Create Project"

          project = Project.find_by!(name: "Games dev")
          expect(project.users.exists?(user.id)).to be(true)

          # Invite team members
          invites = ["jeff.wayne@example.org", "henry.fulton@example.org", "jenna.smith@example.org"]
          fill_in "team_invites_form_members", :with => invites.join("\n")
          click_button "Invite team"

          invites.each do |invite_email|
            team.invited_users.find_by!(email: invite_email)

            email = delivered_emails.find {|mail| mail.to.first == invite_email}
            expect(email).not_to be(nil)
          end

          expect(page).to have_content("Games dev")
        end
      end
    end
  end

  context "when multisite install" do
    context "when setup code is invalid" do
    end

    context "when setup code is valid" do
    end
  end
end
