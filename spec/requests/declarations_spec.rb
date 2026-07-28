require "rails_helper"

RSpec.describe "Declarations", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /declarations" do
    it "正常にレスポンスを返す" do
      get root_path
      expect(response).to have_http_status(:ok)
    end

    it "スコープフィルターが動作する" do
      get root_path(scope: "following")
      expect(response).to have_http_status(:ok)
    end

    it "期間フィルターが動作する" do
      get root_path(period: "today")
      expect(response).to have_http_status(:ok)
    end

    it "カテゴリフィルターが動作する" do
      get root_path(category: "study")
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /declarations" do
    it "有効なパラメータで宣言を作成できる" do
      expect {
        post declarations_path, params: { declaration: { content: "テスト宣言", deadline: Date.today } }
      }.to change(Declaration, :count).by(1)
      expect(response).to redirect_to(root_path)
    end

    it "無効なパラメータではエラーを返す" do
      post declarations_path, params: { declaration: { content: "", deadline: Date.today } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "フォロワーに通知が作成される" do
      follower = create(:user)
      follower.follow(user)
      expect {
        post declarations_path, params: { declaration: { content: "テスト", deadline: Date.today } }
      }.to change(Notification, :count).by(1)
    end
  end

  describe "PATCH /declarations/:id/complete" do
    it "宣言を達成にできる" do
      declaration = create(:declaration, user: user, status: :declaring)
      patch complete_declaration_path(declaration)
      expect(declaration.reload).to be_completed
      expect(response).to redirect_to(root_path)
    end
  end

  context "未ログイン" do
    before { sign_out user }

    it "宣言作成はログインページにリダイレクトされる" do
      post declarations_path, params: { declaration: { content: "テスト", deadline: Date.today } }
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
