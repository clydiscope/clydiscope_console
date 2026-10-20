require "net/http"
require "json"

class FabricationInterpreter
  def interpret(prompt)
    uri = URI("http://127.0.0.1:1234/v1/chat/completions")

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"

    request.body = {
  model: "qwen/qwen3-1.7b",
  messages: [
    {
      role: "system",
      content: "You are a fabrication command translator. Return only a JSON object with operation and size_mm. The only allowed operation is create_cube."
    },
    {
      role: "user",
      content: prompt
    }
    ],
    temperature: 0
    }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    
    http.read_timeout = 120

    response = http.request(request)

    raise "Orko request failed: #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    response

  end
  
end