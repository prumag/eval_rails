class ModelConfig < ApplicationRecord
  has_many :model_responses, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :model_identifier, presence: true

  # Calculates win rate percentage for this model config
  def win_rate
    wins = ModelResponse.joins(:won_evaluations).where(model_config_id: id).count
    losses = ModelResponse.joins(:lost_evaluations).where(model_config_id: id).count
    total = wins + losses
    return 0.0 if total.zero?

    ((wins.to_f / total) * 100).round(1)
  end

  def total_evaluations
    ModelResponse.joins(:won_evaluations).where(model_config_id: id).count +
      ModelResponse.joins(:lost_evaluations).where(model_config_id: id).count
  end

  def average_accuracy
    evals = Evaluation.joins(winner_response: :model_config).where(model_configs: { id: id })
    return 0.0 if evals.empty?

    evals.average(:accuracy_score)&.round(2) || 0.0
  end

  def average_clarity
    evals = Evaluation.joins(winner_response: :model_config).where(model_configs: { id: id })
    return 0.0 if evals.empty?

    evals.average(:clarity_score)&.round(2) || 0.0
  end
end
