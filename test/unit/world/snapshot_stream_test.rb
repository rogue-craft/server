require_relative '../test'

class SnapshotStreamTest < MiniTest::Test

  def test_stream
    run_test([1, 2]) do |stream|
      stream.attach(1, :conn_1)
      stream.attach(2, :conn_2)
    end
  end

  def test_detach_player_id
    run_test([2]) do |stream|
      stream.attach(1, :conn_1)
      stream.attach(2, :conn_2)

      stream.detach_player(1)
    end
  end

  def test_detach_connection
    run_test([1]) do |stream|
      stream.attach(1, :conn_1)
      stream.attach(2, :conn_2)

      stream.detach_connection(:conn_2)
    end
  end

  private
  def run_test(ids)
    factory = mock

    ids.each do |id|
      factory.expects(:create).with(id).returns({snapshot: id})
    end

    sequence = ids.first

    dispatcher = mock
    dispatcher.expects(:dispatch).times(ids.count).yields.with do |msg, conn|
      assert_equal('world/snapshot_stream', msg.target)
      assert_equal("conn_#{sequence}".to_sym, conn)
      assert_equal({snapshot: sequence}, msg.params)

      sequence += 1
    end

    stream = World::SnapshotStream.new(message_dispatcher: dispatcher, snapshot_factory: factory, logger: Logger.new(IO::NULL))

    yield stream

    stream.stream
  end
end
