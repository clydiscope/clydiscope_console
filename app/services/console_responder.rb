require "net/http"
require "json"

class ConsoleResponder
  def initialize(prompt, conversation:)
    @prompt = prompt
    @conversation = conversation
  end

def call
    started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    response = ask_qwen
    @conversation.update(response_id: response["response_id"]) if response["response_id"].present?

    finished_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    {
      status: "complete",
      timestamp: Time.current.strftime("%Y-%m-%d %H:%M:%S"),
      model: "qwen/qwen3-1.7b",
      latency_ms: ((finished_at - started_at) * 1000).round,
      text: extract_message(response)
    }
  end


  private

def conversation_history
  @conversation.messages.order(:created_at).map do |message|
    {
      role: message.role,
      content: message.content
    }
  end
end

def ask_qwen
    uri = URI("http://127.0.0.1:1234/api/v1/chat")

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"

    body = {
      model: "qwen/qwen3-1.7b",
      input: @prompt
    }

    body[:previous_response_id] = @conversation.response_id if @conversation.response_id.present?
    
    request.body = body.to_json

    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end

  def extract_message(response)
    message = response["output"].find do |item|
      item["type"] == "message"
    end

    message["content"]
  end
end