require 'rails_helper'

RSpec.feature "File browser", type: :feature do
  given!(:user) { create(:user, password: "hunter212", password_confirmation: "hunter212") }
  given!(:unauthorized_project) { Project.create(name: "Management", owner: create(:user)) }

  background do
    @unauthorized_attachments = []
    user.projects.create!(name: "UI Design", owner: user)
    user.projects.create!(name: "Engineering", owner: user)

    unauthorized_project.stories.create(name: "First time flow", owner: unauthorized_project.owner).tap do |story|
      @unauthorized_attachments << create(:attachment, story: story)
    end

    sign_in_with user.email, "hunter212"
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
        story = create(:story, project: project, owner: user)
        comment = create(:comment)
        @attachments << create(:attachment, story: story, attachable: comment)
        @attachments << create(:attachment, story: story, attachable: comment)
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
