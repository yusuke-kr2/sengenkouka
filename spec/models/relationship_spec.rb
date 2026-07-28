require "rails_helper"

RSpec.describe Relationship, type: :model do
  describe "バリデーション" do
    it "有効なリレーションシップは保存できる" do
      alice = create(:user)
      bob = create(:user)
      relationship = build(:relationship, follower: alice, following: bob)
      expect(relationship).to be_valid
    end

    it "followerがなければ無効" do
      relationship = build(:relationship, follower: nil)
      expect(relationship).not_to be_valid
    end

    it "followingがなければ無効" do
      relationship = build(:relationship, following: nil)
      expect(relationship).not_to be_valid
    end

    it "同じ組み合わせは重複できない" do
      existing = create(:relationship)
      relationship = build(:relationship, follower: existing.follower, following: existing.following)
      expect(relationship).not_to be_valid
    end

    it "自分自身をフォローできない" do
      user = create(:user)
      relationship = build(:relationship, follower: user, following: user)
      expect(relationship).not_to be_valid
    end
  end
end
