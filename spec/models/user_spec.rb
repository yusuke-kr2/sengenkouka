require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "名前がなければ無効" do
      user = build(:user, name: "")
      expect(user).not_to be_valid
    end

    it "メールがなければ無効" do
      user = build(:user, email: "")
      expect(user).not_to be_valid
    end

    it "有効なユーザーは保存できる" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "メールアドレスは一意" do
      existing = create(:user)
      user = build(:user, email: existing.email)
      expect(user).not_to be_valid
    end
  end

  describe "フォロー機能" do
    let(:alice) { create(:user) }
    let(:bob) { create(:user) }

    it "フォローできる" do
      alice.follow(bob)
      expect(alice).to be_following(bob)
    end

    it "アンフォローできる" do
      alice.follow(bob)
      alice.unfollow(bob)
      expect(alice).not_to be_following(bob)
    end

    it "自分自身はフォローできない" do
      alice.follow(alice)
      expect(alice).not_to be_following(alice)
    end

    it "フォロワーを取得できる" do
      alice.follow(bob)
      expect(bob.followers).to include(alice)
    end
  end

  describe "宣言の削除" do
    it "ユーザー削除で宣言も削除される" do
      user = create(:user)
      create(:declaration, user: user)
      expect { user.destroy }.to change(Declaration, :count).by(-1)
    end
  end

  describe "ストリーク" do
    let(:user) { create(:user) }

    it "increment_streak!でストリークが増える" do
      expect { user.increment_streak! }.to change { user.reload.streak_count }.from(0).to(1)
    end
  end
end
