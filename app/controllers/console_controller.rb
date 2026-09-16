class ConsoleController < ApplicationController
  def index
  end

  def submit
    @prompt = params[:prompt]
      @response = ConsoleResponder.new(@prompt).call

    render :index
  end
end
