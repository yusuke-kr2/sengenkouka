require "rails_helper"

RSpec.describe "Relationships", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before { sign_in user }

  describe "POST /relationships" do
    it "フォローできる" do
      expect {
        post relationships_path, params: { following_id: other_user.id }
      }.to change(Relationship, :count).by(1)
    end
  end

  describe "DELETE /relationships/:id" do
    it "フォロー解除できる" do
      user.follow(other_user)
      relationship = user.active_relationships.find_by(following_id: other_user.id)
      expect {
        delete relationship_path(relationship)
      }.to change(Relationship, :count).by(-1)
    end
  end
end
