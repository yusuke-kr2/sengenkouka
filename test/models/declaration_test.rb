require "test_helper"

class DeclarationTest < ActiveSupport::TestCase
  test "有効な宣言は保存できる" do
    declaration = Declaration.new(content: "テスト", deadline: Date.today, user: users(:alice))
    assert declaration.valid?
  end

  test "内容がなければ無効" do
    declaration = Declaration.new(content: "", deadline: Date.today, user: users(:alice))
    assert_not declaration.valid?
  end

  test "期限がなければ無効" do
    declaration = Declaration.new(content: "テスト", deadline: nil, user: users(:alice))
    assert_not declaration.valid?
  end

  test "過去の日付は無効" do
    declaration = Declaration.new(content: "テスト", deadline: Date.yesterday, user: users(:alice))
    assert_not declaration.valid?
  end

  test "デフォルトステータスはdeclaring" do
    declaration = Declaration.create!(content: "テスト", deadline: Date.today, user: users(:alice))
    assert declaration.declaring?
  end

  test "completedに変更できる" do
    declaration = declarations(:declaring_one)
    declaration.completed!
    assert declaration.completed?
  end

  test "recentスコープは新しい順に並ぶ" do
    declarations = Declaration.recent
    assert_equal declarations, declarations.sort_by(&:created_at).reverse
  end

  test "宣言削除でwitnessも削除される" do
    declaration = declarations(:declaring_one)
    assert_difference "Witness.count", -declaration.witnesses.count do
      declaration.destroy
    end
  end
end
