namespace :redis do
  
  desc "Clean sidekiq jobs"
  task clean_sidekiq: :environment do
    require "sidekiq/api"
    Sidekiq::Queue.new.clear
    Sidekiq::RetrySet.new.clear
  end

  desc "Load ranking in redis"
  task set_ranks: :environment do
    User.select("users.id").joins("JOIN repositories ON users.id=repositories.user_id").where("repositories.language IS NOT NULL").find_each do |user|
      RankWorker.perform_async(user.id)
    end
  end

end