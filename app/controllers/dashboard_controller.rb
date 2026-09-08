class DashboardController < ApplicationController
  def index
    @models = ModelConfig.all.sort_by { |m| -m.win_rate }
    @total_evaluations = Evaluation.count
    @total_prompts = Prompt.count
    @total_responses = ModelResponse.count
    @recent_evaluations = Evaluation.includes(:prompt, winner_response: :model_config).recent.limit(10)
  end
end
