class Test < ApplicationRecord

	belongs_to :request

	scope :failing, -> { where(:status => false) }
    scope :passing, -> { where(:status => true) }

end
