require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  given!(:team) { create(:team) }
  given!(:bob) { create(:user, username: "bob", email: "bob@example.org", password: "hunter212") }

  background do
    create(:team_user, team: team, user: bob)
    switch_to_subdomain(team.subdomain)

    ui_design = bob.projects.create!(name: "UI Design", owner: bob, team_id: team.id)
    engineering = bob.projects.create!(name: "Engineering", owner: bob, team_id: team.id)

    engineering.stories.create!(name: "Speed tunnel testing", owner: bob, team_id: team.id)
    engineering.stories.create!(name: "Prototype v1.0.1", owner: bob, team_id: team.id)
  end

  xscenario "overall projects are listed" do
    sign_in_with bob.email, "hunter212"

    visit "/projects"

    expect(page).to have_content "UI Design"
    expect(page).to have_content "Engineering"
  end

  xscenario "projects load and display stories" do
    sign_in_with bob.email, "hunter212"

    # Page loads
    visit "/projects/engineering"
    expect(page).to have_content "Speed tunnel testing"
    expect(page).to have_content "Prototype v1.0.1"

    # Archiving
    visit "/projects/engineering/edit"
    click_link "archive-btn"
    expect(page).to have_content "Engineering has been archived"

    # Restoring
    click_link "View archived projects (1)"
    click_link "restore-btn"
    expect(page).to have_content "Engineering has been restored"
  end
end
