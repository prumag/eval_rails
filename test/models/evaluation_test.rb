require "test_helper"

class EvaluationTest < ActiveSupport::TestCase
  test "valid evaluation with scores" do
    prompt = Prompt.create!(body: "Test Question?", category: "General")
    evaluation = Evaluation.new(
      prompt: prompt,
      accuracy_score: 5,
      clarity_score: 4,
      instruction_score: 5,
      is_tie: true
    )
    assert evaluation.valid?
  end
end
