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
        return invalid_email unless email_valid(invite_params[:email])

        # Ensure users can only invite team members to
        # projects they have access to.
        invite_params[:project_ids].select! do |pid|
          current_user.project_ids.include?(Integer(pid)) unless pid.empty?
        end

        user = current_team.invite(invite_params, current_user)

        if user.persisted?
          render json: user, serializer: InviteUserSerializer, root: :user
        else
          render_errors user
        end
      end

      api! "Accept an invite"
      param :user, Hash, desc: "Invited user info" do
        param :first_name, String, desc: "Users first name", required: true
        param :last_name, String, desc: "Users last name", required: true
        param :username, String, desc: "Users username", required: true
        param :email, String, desc: "Users email address", required: false
        param :password, String, desc: "Users password", required: true
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
        invite_params = params.require(:user).permit(:email, :project_ids)
        invite_params[:project_ids] = [] unless invite_params[:project_ids].present?

        invite_params
      end

      def user_params
        params.require(:user).permit(:first_name, :last_name, :username, :email,
          :password, :avatar)
      end

      def email_valid(email)
        email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      end

      def invalid_email
        render json: {message: "Validation Failed", errors: { field: "user[email]", errors: ["is invalid"] }}, status: 422
      end
    end
  end
end
