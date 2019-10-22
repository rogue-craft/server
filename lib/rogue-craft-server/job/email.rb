class Job::Email < Job::BaseJob

  FROM = 'noreply@rogue-raft.org'.freeze

  @queue = :email

  def perform(template, addressee, subject, params)
    Mail.deliver do
      from(FROM)
      to(addressee)
      subject(subject)
      # body
    end
  end
end
