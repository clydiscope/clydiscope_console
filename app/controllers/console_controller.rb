class ConsoleController < ApplicationController
  def index
  end

  def submit
    @prompt = params[:prompt]

    if params[:conversation_id].present?
      @conversation = Conversation.find(params[:conversation_id])
    else
      @conversation = Conversation.create!
    end
          
    @response = ConsoleResponder.new(@prompt, conversation: @conversation).call

    render :index
  end
end
