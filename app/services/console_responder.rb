require "net/http"
require "json"

class ConsoleResponder
  def initialize(prompt)
    @prompt = prompt
  end

def call
    started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    response = ask_qwen

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
  
def ask_qwen
    uri = URI("http://127.0.0.1:1234/api/v1/chat")

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"

    request.body = {
      model: "qwen/qwen3-1.7b",
      input: @prompt
    }.to_json

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