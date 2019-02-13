require 'net/http'
require 'net_http_wrapper'

NetHttpWrapper.after_request do |http:, request:, response:, start_time:|
  request_duration = (Time.now - start_time).round(3)
  request_url =
    "http#{'s' if http.use_ssl?}://#{http.address}:#{http.port}#{request.path}"

  puts(url: request_url, status: response.code, duration: request_duration)
end
NetHttpWrapper.enable

Net::HTTP.get('example.com', '/')

# Expected output looks like below:
# {:url=>"http://example.com:80/", :status=>"200", :duration=>0.129}
