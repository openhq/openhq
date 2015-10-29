module Api
  module V1
    class TeamInvitesController < BaseController
      resource_description do
        formats ["json"]
      end

      api! "Invite a user"
      param :user, Hash, desc: "Invited user info" do
        param :email, String, desc: "Email addess of the invitee", required: true
        param :project_ids, Array, of: Integer, desc: "Array of projects ids to attach to the user", required: false
      end
      def create
        invite = Team::Invite.new(invite_params, current_team, current_user)

        if invite.save
          render json: invite.user, serializer: InviteUserSerializer, root: :user
        else
          render_errors invite
        end
      end

      api! "Accept an invite"
      param :user, Hash, desc: "Invited user info" do
        param :first_name, String, desc: "Users first name", required: true
        param :last_name, String, desc: "Users last name", required: true
        param :username, String, desc: "Users username", required: true
        param :email, String, desc: "Users email address", required: false
        param :password, String, desc: "Users password", required: false
        param :avatar, File, desc: "Users avatar", required: false
      end
      def update
        team_user = current_team.user_invites.find_by(invitation_code: params[:id])
        user = team_user.user

        if user.update(user_params)
          team_user.accept_invite!
          render json: user, serializer: InviteUserSerializer, root: :user
        else
          render_errors user
        end
      end

      private

      def invite_params
        params.require(:user).permit(:email, project_ids: [])
      end

      def user_params
        params.require(:user).permit(:first_name, :last_name, :username, :email,
          :password, :avatar)
      end
    end
  end
end
