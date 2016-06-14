class TimelineWaiter
  attr_reader :credential, :options, :latest

  def initialize(credential, **options)
    @credential = credential
    @options    = options
    @latest     = []
  end

  def perform
    started = ts
    loop do
      @latest = credential.tweets.latest(max).to_a
      break if @latest.count >= min || (ts - timeout) > started
      sleep pause_time
    end
    self
  end

  def ts
    Time.now.to_f
  end

  def min
    options.fetch(:min) { 10 }
  end

  def max
    options.fetch(:max) { 100 }
  end

  def timeout
    options.fetch(:timeout) { 20.seconds }
  end

  def pause_time
    options.fetch(:pause) { 1.second }
  end
end
