namespace :tests do
  desc "Update all Requests and Run Tests"
  task run: :environment do
    Request.all.each do |request|
      request.update  
    end
  end
end