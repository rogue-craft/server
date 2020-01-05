require_relative '../test'

class SnapshotStreamTest < MiniTest::Test

  def test_stream
    conn_1 = mock
    conn_2 = mock

    run_test([1, 2], {1 => conn_1, 2 => conn_2})
  end

  private
  def run_test(ids, connections)
    factory = mock

    ids.each do |id|
      factory.expects(:create).with(id).returns({snapshot: id})
    end

    sequence = ids.first

    dispatcher = mock
    dispatcher.expects(:dispatch).times(ids.count).with do |msg, conn|
      assert_equal('snapshot/stream', msg.target)
      assert_equal(connections[sequence], conn)
      assert_equal({snapshot: sequence}, msg.params)

      sequence += 1
    end

    connection_map = connections.invert

    stream = Snapshot::Stream.new(message_dispatcher: dispatcher, connection_map: connection_map, snapshot_factory: factory, logger: Logger.new(IO::NULL))

    stream.stream
  end
end
