require_relative '../test'

class CommandExecutionTest < MiniTest::Test

  def test_execution
    command = {type: :test, params: ['asd']}
    params = {queue: [command]}
    player = mock

    executor = mock
    executor.expects(:call).with(command, player)

    executors = {
      test: executor
    }

    msg = RPC::Message.from(params: params)
    ctx = {player: player}

    handler = Handler::Command.new(command_executors: executors)
    handler.execute(msg, ctx)
  end

  def test_no_executor
    command = {type: :unknown, params: ['asd']}
    params = {queue: [command]}
    player = mock

    executor = mock
    executor.expects(:call).never

    executors = {
      test: executor
    }

    msg = RPC::Message.from(params: params)
    ctx = {player: player}

    handler = Handler::Command.new(command_executors: executors)

    err = assert_raises(ArgumentError) do
      handler.execute(msg, ctx)
    end

    assert_equal("No executor for command type: unknown", err.message)
  end
end
