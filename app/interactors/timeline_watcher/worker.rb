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
          add_error(e)
        end
      end
    rescue => e
      add_error(e)
    end
    self
  end

  def add_error
    errors << e
    logger.error "Worker encountered error: #{e.inspect}\n#{e.backtrace.join("\n")}"
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
