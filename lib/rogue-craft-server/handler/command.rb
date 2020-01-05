class Handler::Command < RPC::InjectedHandler

  include Dependency[:command_executors]

  def execute(msg, ctx)
    msg.params[:queue].each do |command|
      executor = @command_executors[command[:type]]

      unless executor
        raise ArgumentError.new("No executor for command type: #{command[:type]}")
      end

      executor.call(command, ctx[:player])
    end
  end
end
