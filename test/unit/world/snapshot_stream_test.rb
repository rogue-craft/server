require_relative '../test'

class SnapshotStreamTest < MiniTest::Test

  def test_stream
    factory = mock
    factory.expects(:create).with(10)
    factory.expects(:create).with(20)

    stream = World::SnapshotStream.new(snapshot_factory: factory)
    stream.attach(10, :conn_10)
    stream.attach(20, :conn_20)

    stream.stream
  end

  def test_detach_player_id
    factory = mock
    factory.expects(:create).with(20)

    stream = World::SnapshotStream.new(snapshot_factory: factory)
    stream.attach(10, :conn_10)
    stream.attach(20, :conn_20)

    stream.detach_player(10)

    stream.stream
  end

  def test_detach_connection
    factory = mock
    factory.expects(:create).with(10)

    stream = World::SnapshotStream.new(snapshot_factory: factory)
    stream.attach(10, :conn_10)
    stream.attach(20, :conn_20)

    stream.detach_connection(:conn_20)

    stream.stream
  end
end
