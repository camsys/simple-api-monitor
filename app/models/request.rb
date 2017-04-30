class Request < ApplicationRecord
  
  require 'net/http'

  has_many :tests, dependent: :delete_all

  def status
  	(tests.failing.count > 0) ? false : true
  end

  def update
  	begin 
   	  self.response_code, self.response_body = self.call
   	  self.last_updated = Time.now 
   	  self.save 
   	rescue
   	  self.response_code = nil
   	  self.response_body = nil
   	  self.last_updated = Time.now 
   	  self.save 
   	end
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
