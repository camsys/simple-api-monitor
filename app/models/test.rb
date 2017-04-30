class Test < ApplicationRecord

  belongs_to :request

  serialize :key
  serialize :value

  scope :failing, -> { where(:status => false) }
  scope :passing, -> { where(:status => true) }

  def run
  	if request.response_body.nil? or request.response_code.nil?
  	  self.status = false
  	  self.save
  	  return
  	end

  	begin
      body = JSON.parse(request.response_body)
      result = eval(self.key.gsub('body', body.to_s))
      self.status = (result == value)
      self.save
    rescue
      self.status = false
      self.save
     end

  end

end
