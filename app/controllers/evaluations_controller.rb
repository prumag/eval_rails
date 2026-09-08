class EvaluationsController < ApplicationController
  def create
    prompt = Prompt.find(params[:prompt_id])
    response_a = ModelResponse.find(params[:response_a_id])
    response_b = ModelResponse.find(params[:response_b_id])

    winner = nil
    loser = nil
    is_tie = false

    case params[:winner_selection]
    when "response_a"
      winner = response_a
      loser = response_b
    when "response_b"
      winner = response_b
      loser = response_a
    else
      is_tie = true
    end

    evaluation = Evaluation.new(
      prompt: prompt,
      winner_response: winner,
      loser_response: loser,
      is_tie: is_tie,
      accuracy_score: params[:accuracy_score].to_i,
      clarity_score: params[:clarity_score].to_i,
      instruction_score: params[:instruction_score].to_i,
      feedback_notes: params[:feedback_notes],
      evaluator_name: params[:evaluator_name].presence || "Anonymous Evaluator"
    )

    if evaluation.save
      winner_name = is_tie ? "Both Models (Tie)" : winner.model_config.name
      redirect_to dashboard_path, notice: "Evaluation recorded! Winner: #{winner_name}. Leaderboard updated."
    else
      redirect_to prompt_path(prompt), alert: "Could not record evaluation. Please fill required fields."
    end
  end
end
