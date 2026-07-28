require "rails_helper"

RSpec.describe Witness, type: :model do
  describe "バリデーション" do
    it "有効なwitnessは保存できる" do
      witness = build(:witness)
      expect(witness).to be_valid
    end

    it "userがなければ無効" do
      witness = build(:witness, user: nil)
      expect(witness).not_to be_valid
    end

    it "declarationがなければ無効" do
      witness = build(:witness, declaration: nil)
      expect(witness).not_to be_valid
    end

    it "同じユーザーが同じ宣言に重複できない" do
      existing = create(:witness)
      witness = build(:witness, user: existing.user, declaration: existing.declaration)
      expect(witness).not_to be_valid
    end
  end
end
