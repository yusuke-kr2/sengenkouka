require "rails_helper"

RSpec.describe "Profiles", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /profile" do
    it "正常にレスポンスを返す" do
      get profile_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /profile/edit" do
    it "正常にレスポンスを返す" do
      get edit_profile_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /profile" do
    it "プロフィールを更新できる" do
      patch profile_path, params: { user: { name: "新しい名前", bio: "自己紹介" } }
      expect(response).to redirect_to(profile_path)
      expect(user.reload.name).to eq("新しい名前")
    end

    it "名前が空だと更新できない" do
      patch profile_path, params: { user: { name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
