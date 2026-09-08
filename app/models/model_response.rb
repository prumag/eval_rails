class ModelResponse < ApplicationRecord
  belongs_to :prompt
  belongs_to :model_config
  has_many :won_evaluations, class_name: "Evaluation", foreign_key: "winner_response_id", dependent: :nullify
  has_many :lost_evaluations, class_name: "Evaluation", foreign_key: "loser_response_id", dependent: :nullify

  validates :response_text, presence: true
end
