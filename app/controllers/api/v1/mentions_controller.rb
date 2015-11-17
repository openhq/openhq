module Api
  module V1
    class MentionsController < BaseController
      def users
        users = current_team.users.to_a.as_json(only: [:username], methods: [:display_name, :avatar_url])
        render json: users
      end

      def emojis
        render json: Emoji.all.map(&:name)
      end
    end
  end
end
