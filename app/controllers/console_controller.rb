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

    @conversation.messages.create!(role: "user", content: @prompt)

    @response = ConsoleResponder.new(@prompt, conversation: @conversation).call

    @conversation.messages.create!(role: "assistant", content: @response[:text])
    render :index
  end
end
