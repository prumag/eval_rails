class Evaluation < ApplicationRecord
  belongs_to :prompt
  belongs_to :winner_response, class_name: "ModelResponse", optional: true
  belongs_to :loser_response, class_name: "ModelResponse", optional: true

  validates :accuracy_score, inclusion: { in: 1..5 }, allow_nil: true
  validates :clarity_score, inclusion: { in: 1..5 }, allow_nil: true
  validates :instruction_score, inclusion: { in: 1..5 }, allow_nil: true

  scope :recent, -> { order(created_at: :desc) }
end
