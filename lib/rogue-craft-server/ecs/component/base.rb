class ECS::Component::Base

  def initialize
    @lock = Concurrent::ReadWriteLock.new
  end

  def write
    @lock.with_write_lock { yield self }
  end

  def read
    @lock.with_read_lock { yield self }
  end
end
