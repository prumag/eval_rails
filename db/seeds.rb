# db/seeds.rb

puts "Clearing existing data..."
Evaluation.destroy_all
ModelResponse.destroy_all
ModelConfig.destroy_all
Prompt.destroy_all

puts "Creating Model Configurations..."
gemini_flash = ModelConfig.create!(
  name: "Gemini 1.5 Flash (Balanced)",
  provider: "Google Gemini",
  model_identifier: "gemini-1.5-flash",
  temperature: 0.7
)

gemini_pro = ModelConfig.create!(
  name: "Gemini 1.5 Pro (Analytical)",
  provider: "Google Gemini",
  model_identifier: "gemini-1.5-pro",
  temperature: 0.2
)

creative_writer = ModelConfig.create!(
  name: "Gemini Creative (High Temp)",
  provider: "Google Gemini",
  model_identifier: "gemini-1.5-flash",
  temperature: 1.0
)

puts "Creating Sample Prompts..."
p1 = Prompt.create!(
  category: "Reasoning & Logic",
  body: "A train leaves Station A heading East at 60 mph. Another train leaves Station B 100 miles East heading West at 40 mph. When and where do they meet?",
  system_instruction: "Provide step-by-step mathematical breakdown clearly."
)

p2 = Prompt.create!(
  category: "Coding & Tech",
  body: "Write a Ruby method `fibonacci(n)` using memoization that calculates the nth Fibonacci number efficiently.",
  system_instruction: "Write clean, idiomatic Ruby code with documentation comments."
)

p3 = Prompt.create!(
  category: "Creative Writing",
  body: "Write a short 3-sentence poetic story about a software developer coming back to coding after 5 years of meditation.",
  system_instruction: "Evoke themes of clarity, quiet mind, and new perspective."
)

p4 = Prompt.create!(
  category: "Data Analysis",
  body: "Explain the difference between ETL (Extract, Transform, Load) and ELT in cloud data warehousing.",
  system_instruction: "Be precise, concise, and highlight trade-offs."
)

puts "Creating Sample Model Responses & Seed Evaluations..."
# Prompt 1 responses
r1_a = ModelResponse.create!(
  prompt: p1,
  model_config: gemini_flash,
  response_text: "Let's solve step by step:\n1. Total distance = 100 miles.\n2. Combined speed = 60 mph + 40 mph = 100 mph.\n3. Time to meet = Distance / Combined Speed = 100 / 100 = 1 hour.\n4. They meet 60 miles East of Station A.",
  execution_time_ms: 320
)

r1_b = ModelResponse.create!(
  prompt: p1,
  model_config: gemini_pro,
  response_text: "To determine when and where the trains meet:\n- **Relative Speed**: 60 mph + 40 mph = 100 mph.\n- **Time**: t = 100 miles / 100 mph = 1.0 hour.\n- **Location**: Station A train travels 60 miles East; Station B train travels 40 miles West.\nThey meet exactly 1 hour after departure, 60 miles from Station A.",
  execution_time_ms: 540
)

Evaluation.create!(
  prompt: p1,
  winner_response: r1_b,
  loser_response: r1_a,
  is_tie: false,
  accuracy_score: 5,
  clarity_score: 5,
  instruction_score: 5,
  feedback_notes: "Model B formatted the Markdown breakdown much cleaner with clear bold labels.",
  evaluator_name: "Senior Evaluator"
)

# Prompt 2 responses
r2_a = ModelResponse.create!(
  prompt: p2,
  model_config: gemini_pro,
  response_text: "```ruby\n# Calculates nth Fibonacci number using memoization\ndef fibonacci(n, memo = { 0 => 0, 1 => 1 })\n  return memo[n] if memo.key?(n)\n  memo[n] = fibonacci(n - 1, memo) + fibonacci(n - 2, memo)\nend\n```",
  execution_time_ms: 410
)

r2_b = ModelResponse.create!(
  prompt: p2,
  model_config: creative_writer,
  response_text: "```ruby\ndef fib(n)\n  return n if n <= 1\n  a, b = 0, 1\n  (n - 1).times { a, b = b, a + b }\n  b\nend\n```",
  execution_time_ms: 290
)

Evaluation.create!(
  prompt: p2,
  winner_response: r2_a,
  loser_response: r2_b,
  is_tie: false,
  accuracy_score: 5,
  clarity_score: 5,
  instruction_score: 5,
  feedback_notes: "Model A explicitly used recursive memoization as requested in the prompt.",
  evaluator_name: "Ruby Architect"
)

puts "Database successfully seeded!"
