class Request < ApplicationRecord
  has_many :tests

  def status
  	(tests.failing.count > 0) ? false : true
  end
end
