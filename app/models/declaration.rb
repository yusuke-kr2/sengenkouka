class Declaration < ApplicationRecord
  belongs_to :user
  has_many :witnesses, dependent: :destroy

  enum :status, { pending: 0, completed: 1, declaring: 2 }

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
