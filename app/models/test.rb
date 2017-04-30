class Test < ApplicationRecord

  belongs_to :request

  serialize :key
  serialize :value

  scope :failing, -> { where(:status => false) }
  scope :passing, -> { where(:status => true) }

  def run
    body = JSON.parse(request.response_body)
    result = eval(self.key.gsub('body', body.to_s))
    self.status = (result == value)
    self.save
  end

end
