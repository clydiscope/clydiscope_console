class ConsoleController < ApplicationController
  def index
  end

  def submit
    @prompt = params[:prompt]
      @response = {
        status: "complete",
        timestamp: Time.current.strftime("%Y-%m-%d %H:%M:%S"),
        text: "You entered: #{@prompt}"
    }

    render :index
  end
end
