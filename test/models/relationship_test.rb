require "test_helper"

class RelationshipTest < ActiveSupport::TestCase
  test "有効なリレーションシップは保存できる" do
    relationship = Relationship.new(follower: users(:bob), following: users(:charlie))
    assert relationship.valid?
  end

  test "followerがなければ無効" do
    relationship = Relationship.new(follower: nil, following: users(:charlie))
    assert_not relationship.valid?
  end

  test "followingがなければ無効" do
    relationship = Relationship.new(follower: users(:bob), following: nil)
    assert_not relationship.valid?
  end

  test "同じ組み合わせは重複できない" do
    relationship = Relationship.new(follower: users(:alice), following: users(:bob))
    assert_not relationship.valid?
  end

  test "自分自身をフォローできない" do
    relationship = Relationship.new(follower: users(:alice), following: users(:alice))
    assert_not relationship.valid?
  end
end
