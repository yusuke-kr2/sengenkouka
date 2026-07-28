require "rails_helper"

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /users/:id" do
    it "正常にレスポンスを返す" do
      other = create(:user)
      get user_path(other)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /users/:id/followings" do
    it "正常にレスポンスを返す" do
      other = create(:user)
      get followings_user_path(other)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /users/:id/followers" do
    it "正常にレスポンスを返す" do
      other = create(:user)
      get followers_user_path(other)
      expect(response).to have_http_status(:ok)
    end
  end
end
