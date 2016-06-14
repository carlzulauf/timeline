class TimelineWatcher::Worker < Struct.new(:watcher, :credential)
  delegate :logger, :redis, to: :watcher

  attr_reader :id, :thread, :errors

  def perform
    @errors = []
    begin
      @id = SecureRandom.hex(4)
      logger.info "Starting worker #{id}"
      @thread = Thread.new do
        begin
          run_job
          worker_ending
        rescue => e
          errors << e
        end
      end
    rescue => e
      errors << e
    end
    self
  end

  def stop
    thread.kill if running?
  end

  def running?
    thread.present? && thread.alive?
  end

  def run_job
    TimelineWatcher::Job.new(self, credential).perform
  end

  def worker_ending
    logger.info "Ending worker #{id}"
    @thread = nil
  end
end
