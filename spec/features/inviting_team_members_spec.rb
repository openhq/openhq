require 'rails_helper'

RSpec.feature "Inviting team members", type: :feature do
  given!(:user) { create(:user, password: "hunter212", password_confirmation: "hunter212") }
  background do
    user.projects.create!(name: "UI Design", owner: user)
    user.projects.create!(name: "Engineering", owner: user)
    Project.create(name: "Management", owner: create(:user))

    reset_emails!
  end

  scenario "invites a user and assigns them to projects" do
    sign_in_with user.email, "hunter212"

    visit "/team/new"
    fill_in "user_email", :with => "mynewteammember@example.org"
    check "UI Design"
    click_button "Invite"

    # Invitee is created
    invitee = User.find_by!(email: "mynewteammember@example.org")
    expect(invitee.role).to eq("user")

    # Invitee receives an invite email
    expect(last_email.to.first).to eq("mynewteammember@example.org")
    expect(last_email.subject).to eq("Invitation instructions")
    expect(last_email.body).to include("invited")

    # Invitee is assigned a project
    expect(invitee.projects.pluck(:name)).to match_array(["UI Design"])
  end
end
