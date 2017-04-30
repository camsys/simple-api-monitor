class Test < ApplicationRecord

  belongs_to :request

  scope :failing, -> { where(:status => false) }
  scope :passing, -> { where(:status => true) }

  def run
    self.status = true
    self.save

    puts name.ai 
  end

end
