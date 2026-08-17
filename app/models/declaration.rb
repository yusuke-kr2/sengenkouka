class Declaration < ApplicationRecord
  belongs_to :user
  has_many :witnesses, dependent: :destroy
  has_many :declaration_tags, dependent: :destroy
  has_many :tags, through: :declaration_tags

  enum :status, { pending: 0, completed: 1, declaring: 2 }
  enum :category, { study: 0, health: 1, work: 2, hobby: 3, life: 4, other: 5 }

  CATEGORY_LABELS = {
    "study" => "勉強",
    "health" => "健康",
    "work" => "仕事",
    "hobby" => "趣味",
    "life" => "生活",
    "other" => "その他"
  }.freeze

  def category_label
    CATEGORY_LABELS[category] || "その他"
  end

  def expired?
    declaring? && deadline < Date.current
  end

  def editable?
    created_at >= 1.hour.ago
  end

  attr_accessor :tag_names

  after_save :save_tags

  validates :content, presence: true, length: { maximum: 200 }
  validates :deadline, presence: true
  validates :deadline, comparison: { greater_than_or_equal_to: ->(_record) { Date.current }, message: "は今日以降の日付を選択してください" }, allow_blank: true

  scope :recent, -> { order(created_at: :desc) }
  scope :active_declaring, -> { declaring.where("deadline >= ?", Date.current) }
  scope :overdue, -> { declaring.where("deadline < ?", Date.current) }

  private

  def save_tags
    return if tag_names.nil?
    self.tags = tag_names.split(",").map(&:strip).reject(&:blank?).uniq.map do |name|
      Tag.find_or_create_by!(name: name)
    end
  end
end
