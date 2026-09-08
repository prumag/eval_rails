class PromptsController < ApplicationController
  def index
    @category = params[:category]
    @prompts = Prompt.by_category(@category).recent

    # Default to the most recent prompt or sample prompt for instant evaluation
    @selected_prompt = params[:prompt_id].present? ? Prompt.find_by(id: params[:prompt_id]) : @prompts.first

    if @selected_prompt.present?
      prepare_responses_for(@selected_prompt)
    end
  end

  def show
    @selected_prompt = Prompt.find(params[:id])
    prepare_responses_for(@selected_prompt)
    render :index
  end

  def new
    @prompt = Prompt.new
  end

  def create
    @prompt = Prompt.new(prompt_params)

    if @prompt.save
      # Automatically trigger dual AI model responses
      GeminiEvaluatorService.generate_pair(prompt: @prompt)
      redirect_to prompt_path(@prompt), notice: "Prompt submitted! AI model responses are ready for evaluation."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def prompt_params
    params.require(:prompt).permit(:body, :category, :system_instruction)
  end

  def prepare_responses_for(prompt)
    responses = prompt.model_responses.includes(:model_config)
    if responses.count < 2
      GeminiEvaluatorService.generate_pair(prompt: prompt)
      responses = prompt.model_responses.reload.includes(:model_config)
    end

    # Shuffle responses for a true blind test (Model A vs Model B)
    @response_a = responses.first
    @response_b = responses.second
    @existing_evaluation = prompt.evaluations.last
  end
end
