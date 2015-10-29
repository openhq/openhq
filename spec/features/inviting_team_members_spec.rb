require 'rails_helper'

RSpec.feature "Inviting team members", type: :feature do
  include ActiveJob::TestHelper

  given!(:team) { create(:team) }
  given!(:user) { create(:user, password: "hunter212") }

  background do
    team.team_users.create!(user: user, role: "user")
    switch_to_subdomain(team.subdomain)

    user.projects.create!(name: "UI Design", owner: user, team_id: team.id)
    user.projects.create!(name: "Engineering", owner: user, team_id: team.id)
    Project.create(name: "Management", owner: create(:user), team_id: team.id)

    reset_emails!
  end

  xscenario "invites a user and assigns them to projects" do
    perform_enqueued_jobs do
      sign_in_with user.email, "hunter212"

      visit "/team_invites/new"
      fill_in "user_email", :with => "mynewteammember@example.org"
      check "UI Design"
      click_button "Invite"

      # Invitee is created
      invitee = User.find_by!(email: "mynewteammember@example.org")
      expect(invitee.team_invites.first.role).to eq("user")


      # Invitee receives an invite email
      expect(last_email.to.first).to eq("mynewteammember@example.org")
      expect(last_email.subject).to eq("You have been invited to join a team on Open HQ")
      expect(last_email.body).to include("invited")

      # Invitee is assigned a project
      expect(invitee.projects.pluck(:name)).to match_array(["UI Design"])
    end
  end
end
