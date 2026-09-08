require "test_helper"

class PromptTest < ActiveSupport::TestCase
  test "valid prompt with body and category" do
    prompt = Prompt.new(body: "Test Question?", category: "General")
    assert prompt.valid?
  end

  test "invalid without body" do
    prompt = Prompt.new(category: "General")
    assert_not prompt.valid?
  end
end
