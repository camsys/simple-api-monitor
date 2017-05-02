class PagerDuty

  require 'net/http'

  def trigger failures
  	url = "https://events.pagerduty.com/generic/2010-04-15/create_event.json"

  	hash = {    
		  "service_key": ENV['PAGER_DUTY_SERVICE_KEY'],
		  "event_type": "trigger",
		  "description": "Failed Events Detected",
		  "details": failures
		}
  	call url, hash 
  end	

  def call url, hash
    uri = URI.parse(url)
    req = Net::HTTP::Post.new(uri.to_s, 'Content-Type': 'application/json')
    req.body = hash.to_json 
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) {|http|
      http.request(req)
    }
    return res.code, res.body
  end

end