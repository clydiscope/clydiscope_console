class FabricationsController < ApplicationController
  def index
  end

  def create
    prompt = params[:prompt]

    response = FabricationOrchestrator.new.create(prompt)

    @result = JSON.parse(response.body)

    render :index

    def create
      prompt = params[:prompt]

      response = FabricationOrchestrator.new.create(prompt)

      @result = JSON.parse(response.body)
      Rails.logger.info "FABRICATION RESPONSE: #{@result.inspect}"
      @job_id = @result["job_id"]

      render :index
    rescue InvalidAIResponseError
      @error = "Orko couldn't understand the fabrication request."
      render :index, status: :unprocessable_entity
    rescue InvalidFabricationCommandError
      @error = "That fabrication command exceeds our permitted operations or dimensions."
      render :index, status: :unprocessable_entity
    end
  end

  def download
    stl = FabricationService.new.download_cube(params[:job_id])
    send_data stl,
      filename: "clydiscope_cube.stl",
      type: "model/stl",
      disposition: "attachment"
  end
end
