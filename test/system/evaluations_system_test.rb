require_relative "application_system_test_case"

class EvaluationsSystemTest < ApplicationSystemTestCase
  test "visiting the evaluation arena homepage" do
    visit root_url
    assert_selector "h1", text: "AI Model Evaluation Arena"
  end
end
