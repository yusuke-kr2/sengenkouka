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

  attr_accessor :tag_names

  after_save :save_tags

  private

  def save_tags
    return if tag_names.nil?
    self.tags = tag_names.split(",").map(&:strip).reject(&:blank?).uniq.map do |name|
      Tag.find_or_create_by!(name: name)
    end
  end

  validates :content, presence: true
  validates :deadline, presence: true
  validate :deadline_cannot_be_in_the_past

  private

  def deadline_cannot_be_in_the_past
    return if deadline.blank?
    errors.add(:base, :deadline_in_the_past) if deadline < Date.today
  end

  scope :recent, -> { order(created_at: :desc) }
end
