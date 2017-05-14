class Request < ApplicationRecord
  
  require 'net/http'

  has_many :tests, dependent: :delete_all

  serialize :headers

  #Validations
  validates :name, presence: true
  validates :url, presence: true

  #Constants
  SUPPORTED_FORMATS = ['xml', 'json']

  def status
  	(tests.failing.count > 0) ? false : true
  end

  def refresh
    new_failures = []

  	#### Make the call
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

   	#### Run all the tests associated with the call
    tests.each do |test|
   	  if test.run  
        new_failures << "#{self.name}: #{test.name}"
      end  
   	end
     
    return new_failures
   
   end

  def call 
    # The following will find all instances of _{ blah }_ and then evaluate the blah
    # E.g., 'http://www.checksomething.com/at/_{(Time.now+2.weeks).strftime('%d-%m-%Y')}_' will be translated into
    #       'http://www.checksomething.com/at/22-05-2017' # (Assuming that the request is run on May 8, 2017)
    url = self.evaluate
    uri = URI.parse(url)
    req = Net::HTTP::Get.new(uri.to_s)
    
    # Add Custom Headers
    unless headers.nil?
      headers.each do |key, value|
        req.add_field key.to_s, value.to_s
      end
    end

    # Handle Format
    if format == "xml"
      req.add_field "Content-Type", "text/xml"
    end

    res = Net::HTTP.start(uri.host, uri.port, use_ssl: use_ssl, verify_mode: OpenSSL::SSL::VERIFY_NONE) {|http|
      http.request(req)
    }
    return res.code, res.body
  end

  def evaluate
    return url.gsub(/\_{(.*?)\}_/) { eval($1) }
  end

end
