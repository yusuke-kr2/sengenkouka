require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    it "未ログインでランディングページを表示する" do
      get root_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /how_to_use" do
    it "正常にレスポンスを返す" do
      get how_to_use_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /privacy_policy" do
    it "正常にレスポンスを返す" do
      get privacy_policy_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /terms_of_service" do
    it "正常にレスポンスを返す" do
      get terms_of_service_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /contact" do
    it "正常にレスポンスを返す" do
      get contact_path
      expect(response).to have_http_status(:ok)
    end
  end
end
