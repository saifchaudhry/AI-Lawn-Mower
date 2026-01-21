require_relative '../config/environment'

Handler = Proc.new do |event|
  # Parse the request
  request_method = event['requestContext']['http']['method']
  path = event['rawPath'] || '/'
  query_string = event['rawQueryString'] || ''
  headers = event['headers'] || {}
  body = event['body'] || ''

  # Build Rack environment
  env = {
    'REQUEST_METHOD' => request_method,
    'SCRIPT_NAME' => '',
    'PATH_INFO' => path,
    'QUERY_STRING' => query_string,
    'SERVER_NAME' => headers['host'] || 'localhost',
    'SERVER_PORT' => '443',
    'rack.version' => Rack::VERSION,
    'rack.url_scheme' => 'https',
    'rack.input' => StringIO.new(body),
    'rack.errors' => $stderr,
    'rack.multithread' => false,
    'rack.multiprocess' => true,
    'rack.run_once' => false,
    'rack.hijack?' => false,
    'CONTENT_TYPE' => headers['content-type'] || '',
    'CONTENT_LENGTH' => body.bytesize.to_s
  }

  # Add HTTP headers
  headers.each do |key, value|
    env_key = "HTTP_#{key.upcase.gsub('-', '_')}"
    env[env_key] = value unless key == 'content-type' || key == 'content-length'
  end

  # Call Rails application
  status, response_headers, response_body = Rails.application.call(env)

  # Build response body
  body_content = []
  response_body.each { |part| body_content << part }
  response_body.close if response_body.respond_to?(:close)

  # Return response in AWS Lambda format
  {
    statusCode: status,
    headers: response_headers,
    body: body_content.join
  }
end
