class FabricationsController < ApplicationController
  def index
  end

  def create
    prompt = params[:prompt]

    response = FabricationOrchestrator.new.create(prompt)

    @result = JSON.parse(response.body)

    render :index
  end
  def download
    stl = FabricationService.new.download_cube

    send_data stl,
      filename: "clydiscope_cube.stl",
      type: "model/stl",
      disposition: "attachment"
  end
end
