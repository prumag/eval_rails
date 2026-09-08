module Api
  class EvaluationsController < ApplicationController
    def index
      evaluations = Evaluation.includes(:prompt, winner_response: :model_config, loser_response: :model_config).recent

      render json: {
        exported_at: Time.current,
        total_records: evaluations.count,
        benchmark_dataset: evaluations.map { |eval| format_evaluation(eval) }
      }
    end

    private

    def format_evaluation(eval)
      {
        id: eval.id,
        category: eval.prompt.category,
        prompt: eval.prompt.body,
        system_instruction: eval.prompt.system_instruction,
        is_tie: eval.is_tie,
        winner_model: eval.winner_response&.model_config&.name,
        loser_model: eval.loser_response&.model_config&.name,
        accuracy_score: eval.accuracy_score,
        clarity_score: eval.clarity_score,
        instruction_score: eval.instruction_score,
        feedback_notes: eval.feedback_notes,
        evaluator: eval.evaluator_name,
        evaluated_at: eval.created_at
      }
    end
  end
end
