class Test < ApplicationRecord

  belongs_to :request

  serialize :key
  serialize :value

  scope :failing, -> { where(:status => false) }
  scope :passing, -> { where(:status => true) }

  def run

  	if request.response_body.nil? or request.response_code.nil?
      new_failure = self.new_failure? false
      self.status = false
  	  self.save
  	  return new_failure
  	end

  	begin
      body = JSON.parse(request.response_body)
      result = eval(self.key.gsub('body', body.to_s))
      new_status = (result == value)
      new_failure = self.new_failure? new_status
      self.status = new_status
      self.save
      return new_failure
    rescue
      new_failure = self.new_failure? false
      self.status = false
      self.save
      return new_failure 
     end

  end

  def new_failure? new_status
    if self.status and not new_status
      return true
    else
      return false
    end
  end

end
