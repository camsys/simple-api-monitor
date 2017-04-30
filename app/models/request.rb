class Request < ApplicationRecord
  
  require 'net/http'

  has_many :tests

  attr_reader :response_code
  attr_reader :response_body

  def status
  	(tests.failing.count > 0) ? false : true
  end

  def update
   	@response_code, @response_body = self.call
   	tests.each do |test|
   	  test.run
    end
  end

  def call 
    uri = URI.parse(url)
    req = Net::HTTP::Get.new(uri.to_s)
    res = Net::HTTP.start(uri.host, uri.port) {|http|
      http.request(req)
    }
    return res.code, res.body
  end
end
