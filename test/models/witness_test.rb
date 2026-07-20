require "test_helper"

class WitnessTest < ActiveSupport::TestCase
  test "有効なwitnessは保存できる" do
    witness = Witness.new(user: users(:charlie), declaration: declarations(:declaring_one))
    assert witness.valid?
  end

  test "userがなければ無効" do
    witness = Witness.new(user: nil, declaration: declarations(:declaring_one))
    assert_not witness.valid?
  end

  test "declarationがなければ無効" do
    witness = Witness.new(user: users(:charlie), declaration: nil)
    assert_not witness.valid?
  end

  test "同じユーザーが同じ宣言に重複できない" do
    witness = Witness.new(user: users(:bob), declaration: declarations(:declaring_one))
    assert_not witness.valid?
  end
end
