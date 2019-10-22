class Job::BaseJob
  def self.perform(*args)
    new.perform(*args)
  end
end
