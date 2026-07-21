require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "名前がなければ無効" do
    user = User.new(name: "", email: "test@example.com", password: "password123")
    assert_not user.valid?
  end

  test "メールがなければ無効" do
    user = User.new(name: "Test", email: "", password: "password123")
    assert_not user.valid?
  end

  test "有効なユーザーは保存できる" do
    user = User.new(name: "Test", email: "new@example.com", password: "password123")
    assert user.valid?
  end

  test "メールアドレスは一意" do
    user = User.new(name: "Dup", email: users(:alice).email, password: "password123")
    assert_not user.valid?
  end

  test "フォローできる" do
    alice = users(:alice)
    charlie = users(:charlie)
    alice.follow(charlie)
    assert alice.following?(charlie)
  end

  test "アンフォローできる" do
    alice = users(:alice)
    bob = users(:bob)
    assert alice.following?(bob)
    alice.unfollow(bob)
    assert_not alice.following?(bob)
  end

  test "自分自身はフォローできない" do
    alice = users(:alice)
    alice.follow(alice)
    assert_not alice.following?(alice)
  end

  test "フォロワーを取得できる" do
    bob = users(:bob)
    assert_includes bob.followers, users(:alice)
  end

  test "ユーザー削除で宣言も削除される" do
    alice = users(:alice)
    assert_difference "Declaration.count", -alice.declarations.count do
      alice.destroy
    end
  end

  test "increment_streak!でストリークが増える" do
    alice = users(:alice)
    assert_equal 0, alice.streak_count
    alice.increment_streak!
    assert_equal 1, alice.reload.streak_count
  end

  test "期限切れの宣言があるとストリークがリセットされる" do
    alice = users(:alice)
    alice.update!(streak_count: 5)
    Declaration.create!(content: "期限切れテスト", deadline: Date.today, status: :declaring, user: alice)
      .update_column(:deadline, Date.yesterday)
    alice.reset_streak_if_expired!
    assert_equal 0, alice.reload.streak_count
  end

  test "期限切れがなければストリークはリセットされない" do
    alice = users(:alice)
    alice.update!(streak_count: 3)
    alice.reset_streak_if_expired!
    assert_equal 3, alice.reload.streak_count
  end
end
