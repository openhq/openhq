require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  given!(:bob) { create(:user, username: "bob", email: "bob@example.org", password: "hunter212", password_confirmation: "hunter212") }

  background do
    ui_design = bob.projects.create!(name: "UI Design", owner: bob)
    engineering = bob.projects.create!(name: "Engineering", owner: bob)

    engineering.stories.create!(name: "Speed tunnel testing", owner: bob)
    engineering.stories.create!(name: "Prototype v1.0.1", owner: bob)
  end

  scenario "overall projects are listed" do
    sign_in_with bob.email, "hunter212"

    visit "/projects"

    expect(page).to have_content "UI Design"
    expect(page).to have_content "Engineering"
  end

  scenario "projects load and display stories" do
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
