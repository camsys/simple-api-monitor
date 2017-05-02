namespace :tests do
  desc "Update all Requests and Run Tests"
  task run: :environment do
    Updater.new.update_all
  end
end