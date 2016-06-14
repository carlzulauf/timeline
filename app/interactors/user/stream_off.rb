class User::StreamOff < Struct.new(:user)
  def perform
    redis.zrem :users, user.id
  end

  def redis
    TimelineWatcher.redis
  end
end
