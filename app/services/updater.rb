class Updater
  
  def update_all

  	new_failures = []
    Request.all.each do |request|
      new_failures += request.update  
    end
  
  	unless new_failures.count == 0
      PagerDuty.new.trigger new_failures
    end

  end

end