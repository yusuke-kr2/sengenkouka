require "rails_helper"

RSpec.describe "Searches", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /search" do
    it "正常にレスポンスを返す" do
      get search_path
      expect(response).to have_http_status(:ok)
    end

    it "クエリで検索できる" do
      other = create(:user, name: "検索対象ユーザー")
      get search_path(q: "検索対象")
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("検索対象ユーザー")
    end
  end

  describe "GET /search/suggestions" do
    it "JSONで候補を返す" do
      create(:user, name: "サジェストテスト")
      get search_suggestions_path(q: "サジェスト"), as: :json
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to include("サジェストテスト")
    end

    it "空クエリで空配列を返す" do
      get search_suggestions_path(q: ""), as: :json
      expect(response.parsed_body).to eq([])
    end
  end
end
