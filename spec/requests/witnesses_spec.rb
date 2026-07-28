require "rails_helper"

RSpec.describe "Witnesses", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /witnesses" do
    it "正常にレスポンスを返す" do
      get witnesses_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /witnesses" do
    it "見届けできる" do
      other = create(:user)
      declaration = create(:declaration, user: other)
      expect {
        post witnesses_path, params: { declaration_id: declaration.id }
      }.to change(Witness, :count).by(1)
    end

    it "自分の宣言には見届けできない" do
      declaration = create(:declaration, user: user)
      expect {
        post witnesses_path, params: { declaration_id: declaration.id }
      }.not_to change(Witness, :count)
    end
  end

  describe "DELETE /witnesses/:id" do
    it "見届けを取り消せる" do
      other = create(:user)
      declaration = create(:declaration, user: other)
      witness = create(:witness, user: user, declaration: declaration)
      expect {
        delete witness_path(witness)
      }.to change(Witness, :count).by(-1)
    end
  end
end
