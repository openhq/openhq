require 'rails_helper'

RSpec.feature "File browser", type: :feature do
  given!(:team) { create(:team) }
  given!(:user) { create(:user, password: "hunter212") }
  given!(:team_user) { create(:team_user, user: user, team: team) }
  given!(:unauthorized_project) { Project.create(name: "Management", owner: create(:user)) }

  background do
    switch_to_subdomain(team.subdomain)

    @unauthorized_attachments = []
    user.projects.create!(name: "UI Design", owner: user, team_id: team.id)
    user.projects.create!(name: "Engineering", owner: user, team_id: team.id)

    unauthorized_project.stories.create(name: "First time flow", team_id: team.id, owner: unauthorized_project.owner).tap do |story|
      @unauthorized_attachments << create(:attachment, story: story)
    end

    sign_in_with user.email, "hunter212"
  end

  after do
    switch_to_main_domain
  end

  context "when user has no files" do
    scenario "displays a friendly message" do
      visit "/files"
      expect(page).to have_content "You don’t have any files across your projects"
    end
  end

  context "when user has some files" do
    background do
      @attachments = []
      user.projects.each do |project|
        story = create(:story, project: project, owner: user, team_id: team.id)
        comment = create(:comment, team_id: team.id)
        @attachments << create(:attachment, story: story, attachable: comment, team_id: team.id)
        @attachments << create(:attachment, story: story, attachable: comment, team_id: team.id)
      end
    end

    scenario "displays those files" do
      visit "/files"

      @attachments.each do |file|
        file_name = file.file_name.truncate(25, separator: ' ')
        expect(page).to have_content(file_name)
      end
    end

    context "for projects the user isn’t a member of" do
      scenario "doesn’t display their files" do
        visit "/files"

        @unauthorized_attachments.each do |file|
          file_name = file.file_name.truncate(25, separator: ' ')
          expect(page).not_to have_content(file_name)
        end
      end
    end
  end
end
