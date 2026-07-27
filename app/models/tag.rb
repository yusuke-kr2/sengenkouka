class Tag < ApplicationRecord
  has_many :declaration_tags, dependent: :destroy
  has_many :declarations, through: :declaration_tags

  validates :name, presence: true, uniqueness: true
end
