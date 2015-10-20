require 'rails_helper'

RSpec.describe ApiToken, type: :model do
  it { should belong_to :user }
  it { should belong_to :team }
  it { should validate_presence_of :user }
  it { should validate_presence_of :team }

  it "generates a token on creation" do
    api_token = create(:api_token)
    expect(api_token.token).not_to be(:empty)
  end

  describe ".for(user, team)" do
    let!(:user) { create(:user) }
    let!(:team) { create(:team) }

    context "when no token exists" do
      it "creates a new token" do
        expect do
          token = ApiToken.for(user, team)
          expect(token.token).not_to be(:empty)
        end.to change(ApiToken, :count).by(1)
      end
    end

    context "when token already exists" do
      let!(:existing_token) { create(:api_token, user: user, team: team) }

      it "loads the existing token" do
        expect(ApiToken.for(user, team).id).to eq(existing_token.id)
      end
    end
  end
end
