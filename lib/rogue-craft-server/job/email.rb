class Job::Email < Job::BaseJob

  FROM = 'noreply@roguecraft.org'.freeze

  @queue = :email

  def perform(type, addressee, params)
    subject = subject_of(type)
    body = body_of(type, params)

    Mail.deliver do
      from(FROM)
      to(addressee)
      subject(subject)
      body(body)
    end
  end

  private
  def subject_of(type)
    case type
    when 'activation'
      "RougeCraft account activation"
    else
      raise ArgumentError.new("Unkown email type #{type}")
    end
  end

  def body_of(type, params)
    case type
    when 'activation'
      "Activation code: #{params[:code]}"
    else
      raise ArgumentError.new("Unkown email type #{type}")
    end
  end
end
