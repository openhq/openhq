require 'rails_helper'

RSpec.feature "Stories", type: :feature do
  given!(:team) { create(:team) }
  given!(:bob) { create(:user, username: "bob", email: "bob@example.org", password: "hunter212") }
  given!(:sarah) { create(:user, username: "sarah", email: "sarah@example.org", password: "hunter212") }

  background do
    create(:team_user, team: team, user: bob)
    create(:team_user, team: team, user: sarah)
    switch_to_subdomain(team.subdomain)

    ui_design = bob.projects.create!(name: "UI Design", owner: bob, team: team)
    engineering = sarah.projects.create!(name: "Engineering", owner: sarah, team: team)

    bob.projects << engineering

    @story = engineering.stories.create!(name: "Speed tunnel testing", owner: bob, team: team)

    @story.comments.create!(content: "Hey @bob", owner: sarah, team: team)
  end

  xscenario "invites a user and assigns them to projects" do
    sign_in_with bob.email, "hunter212"

    # Page loads
    visit "/projects/engineering/stories/speed-tunnel-testing"
    expect(page).to have_content "Hey @bob"

    # Leaving a new comment
    fill_in "comment_content", with: "Hi @sarah"
    click_button "Reply"
    expect(page).to have_content "Hi @sarah"

    # Editing your own comment
    within "article[data-owner-id=\"#{bob.id}\"]" do
      click_link("Edit")
    end

    fill_in "comment_content", with: "Hello me!"
    click_button "Save changes"

    expect(page).not_to have_content "Hi @sarah"
    expect(page).to have_content "Hello me!"

    # Deleting your own comment
    within "article[data-owner-id=\"#{bob.id}\"]" do
      click_link("Delete")
    end

    expect(page).not_to have_content "Hello me!"
  end
end
