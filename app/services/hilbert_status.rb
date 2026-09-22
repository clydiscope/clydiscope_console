require "net/http"

class HilbertStatus

def check_status?
  uri = URI("http://127.0.0.1:1235/api/v1/models")

  begin
    http = Net::HTTP.new(uri.host, uri.port)
    http.read_timeout = 20

    response = http.get(uri.path)
    data = JSON.parse(response.body)
    true
  rescue 
    false
  end
end


end