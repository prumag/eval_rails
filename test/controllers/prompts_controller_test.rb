require "test_helper"

class PromptsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get prompts_url
    assert_response :success
  end

  test "should get new" do
    get new_prompt_url
    assert_response :success
  end

  test "should create prompt" do
    assert_difference("Prompt.count") do
      post prompts_url, params: { prompt: { body: "New Test Prompt", category: "General" } }
    end
    assert_redirected_to prompt_url(Prompt.last)
  end
end
