class Prompt < ApplicationRecord
  has_many :model_responses, dependent: :destroy
  has_many :evaluations, dependent: :destroy

  validates :body, presence: true
  validates :category, presence: true

  CATEGORIES = ["General", "Coding & Tech", "Reasoning & Logic", "Creative Writing", "Data Analysis"].freeze

  scope :by_category, ->(cat) { where(category: cat) if cat.present? }
  scope :recent, -> { order(created_at: :desc) }
end
