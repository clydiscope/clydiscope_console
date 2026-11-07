require "net/http"
require "json"

class FabricationService
  def create_cube(size_mm)
    uri = URI("http://127.0.0.1:8000/create_cube")

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request.body = { size_mm: size_mm }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(request)
  end

  def download_cube(job_id)
    uri = URI("http://127.0.0.1:8000/download_cube/#{job_id}")
    response = Net::HTTP.get_response(uri)

    raise "STL download failed: #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    response.body
  end
end
