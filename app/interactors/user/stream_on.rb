class User::StreamOn < Struct.new(:user)
  def perform
    redis.zadd :users, Time.now.to_f, user.id
  end

  def redis
    TimelineWatcher.redis
  end
end
