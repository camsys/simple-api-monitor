class Requestor
  attr_reader :response_code, :response_body

  def initialize request
    @request = request
    @response_code = nil
    @response_body = nil
  end
  # Make all of the HTTP requests that have been added to the bundler
  def call
    @response_body = "ok"
    @response_code = 200
  end

end