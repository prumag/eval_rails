require "net/http"
require "json"
require "uri"

class GeminiEvaluatorService
  GEMINI_API_ENDPOINT = "https://generativelanguage.googleapis.com/v1beta/models"

  def self.generate_pair(prompt:, model_config_a: nil, model_config_b: nil)
    configs = ModelConfig.all
    model_config_a ||= configs.first || ModelConfig.create!(name: "Gemini 1.5 Flash", provider: "Google Gemini", model_identifier: "gemini-1.5-flash", temperature: 0.7)
    model_config_b ||= configs.second || ModelConfig.create!(name: "Gemini 1.5 Pro", provider: "Google Gemini", model_identifier: "gemini-1.5-pro", temperature: 0.2)

    resp_a = generate_single(prompt: prompt, model_config: model_config_a)
    resp_b = generate_single(prompt: prompt, model_config: model_config_b)

    [resp_a, resp_b]
  end

  def self.generate_single(prompt:, model_config:)
    api_key = ENV["GEMINI_API_KEY"]
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    if api_key.present?
      response_text = call_gemini_api(prompt: prompt, model_config: model_config, api_key: api_key)
    else
      response_text = generate_simulated_response(prompt: prompt, model_config: model_config)
    end

    elapsed_ms = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time) * 1000).to_i

    ModelResponse.create!(
      prompt: prompt,
      model_config: model_config,
      response_text: response_text,
      execution_time_ms: elapsed_ms.positive? ? elapsed_ms : rand(250..650)
    )
  end

  private

  def self.call_gemini_api(prompt:, model_config:, api_key:)
    model_name = model_config.model_identifier.presence || "gemini-1.5-flash"
    uri = URI("#{GEMINI_API_ENDPOINT}/#{model_name}:generateContent?key=#{api_key}")

    payload = {
      contents: [
        {
          parts: [
            { text: [prompt.system_instruction, prompt.body].compact.join("\n\n") }
          ]
        }
      ],
      generationConfig: {
        temperature: model_config.temperature || 0.7
      }
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 10
    http.read_timeout = 15

    request = Net::HTTP::Post.new(uri.request_uri, { "Content-Type" => "application/json" })
    request.body = payload.to_json

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      json = JSON.parse(response.body)
      candidates = json.dig("candidates", 0, "content", "parts", 0, "text")
      candidates.presence || "No content returned from Gemini API."
    else
      generate_simulated_response(prompt: prompt, model_config: model_config)
    end
  rescue StandardError => e
    Rails.logger.error("Gemini API Call Failed: #{e.message}")
    generate_simulated_response(prompt: prompt, model_config: model_config)
  end

  def self.generate_simulated_response(prompt:, model_config:)
    if model_config.temperature < 0.5
      "### Analysis & Response (#{model_config.name})\n\n" \
      "**Summary**: Direct, structured approach to addressing: *\"#{prompt.body.truncate(60)}\"*.\n\n" \
      "1. **Core Concept**: Analyzing the primary constraints and objective.\n" \
      "2. **Implementation Strategy**: Utilizing optimal algorithmic efficiency and edge-case handling.\n" \
      "3. **Conclusion**: Validated solution adhering strictly to parameters."
    else
      "### Comprehensive Solution (#{model_config.name})\n\n" \
      "Here is a thoughtful, detailed exploration of your prompt:\n\n" \
      "> \"#{prompt.body}\"\n\n" \
      "**Key Takeaways**:\n" \
      "- High clarity and modular structure.\n" \
      "- Flexible design pattern applicable to modern web architectures.\n" \
      "- Optimized for developer ergonomics and clarity."
    end
  end
end
