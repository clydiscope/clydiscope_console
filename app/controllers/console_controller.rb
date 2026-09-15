class ConsoleController < ApplicationController
  def index
  end

  def submit
    @prompt = params[:prompt]
    @response = "You entered: #{@prompt}"

    render :index
  end
end
