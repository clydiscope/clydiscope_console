class ConsoleController < ApplicationController
  def index
    @conversations = Conversation.order(created_at: :desc)
  end

  def submit
    @conversations = Conversation.order(created_at: :desc)
    @prompt = params[:prompt]

    if params[:conversation_id].present?
      @conversation = Conversation.find(params[:conversation_id])
    else
      @conversation = Conversation.create!(title: @prompt.truncate(30))
    end

    @conversation.messages.create!(role: "user", content: @prompt)

    @response = ConsoleResponder.new(@prompt, conversation: @conversation).call

    @conversation.messages.create!(role: "assistant", content: @response[:text])
    render :index
  end

  def show
    @conversation = Conversation.find(params[:id])
    @conversations = Conversation.order(created_at: :desc)
    render :index
  end
end
