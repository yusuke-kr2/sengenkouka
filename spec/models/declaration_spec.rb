require "rails_helper"

RSpec.describe Declaration, type: :model do
  describe "バリデーション" do
    it "有効な宣言は保存できる" do
      declaration = build(:declaration)
      expect(declaration).to be_valid
    end

    it "内容がなければ無効" do
      declaration = build(:declaration, content: "")
      expect(declaration).not_to be_valid
    end

    it "期限がなければ無効" do
      declaration = build(:declaration, deadline: nil)
      expect(declaration).not_to be_valid
    end

    it "過去の日付は無効" do
      declaration = build(:declaration, deadline: Date.yesterday)
      expect(declaration).not_to be_valid
    end
  end

  describe "ステータス" do
    it "デフォルトステータスはdeclaring" do
      declaration = create(:declaration)
      expect(declaration).to be_declaring
    end

    it "completedに変更できる" do
      declaration = create(:declaration)
      declaration.completed!
      expect(declaration).to be_completed
    end
  end

  describe "スコープ" do
    it "recentスコープは新しい順に並ぶ" do
      user = create(:user)
      old = create(:declaration, content: "古い宣言", user: user)
      new_one = create(:declaration, content: "新しい宣言", user: user)
      declarations = Declaration.recent
      expect(declarations.index(new_one)).to be < declarations.index(old)
    end
  end

  describe "関連の削除" do
    it "宣言削除でwitnessも削除される" do
      declaration = create(:declaration)
      create(:witness, declaration: declaration)
      expect { declaration.destroy }.to change(Witness, :count).by(-1)
    end
  end
end
