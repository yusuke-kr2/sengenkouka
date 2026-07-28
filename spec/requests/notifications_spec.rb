require "rails_helper"

RSpec.describe "Notifications", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /notifications" do
    it "正常にレスポンスを返す" do
      get notifications_path
      expect(response).to have_http_status(:ok)
    end

    it "未読通知が既読になる" do
      actor = create(:user)
      declaration = create(:declaration, user: actor)
      create(:notification, user: user, actor: actor, declaration: declaration, read: false)
      get notifications_path
      expect(user.notifications.unread.count).to eq(0)
    end
  end
end
