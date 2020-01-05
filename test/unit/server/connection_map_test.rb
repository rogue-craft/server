require_relative '../test'

class ConnectionMapTest < MiniTest::Test

  def test_map
    map = new_map

    map.attach(:conn_1, 1)
    map.attach(:conn_2, 2)

    assert_equal(2, map.player_id_of(:conn_2))
    assert_equal(1, map.player_id_of(:conn_1))

    map.remove_connection(:conn_2)

    assert_raises(KeyError) do
      map.player_id_of(:conn_2)
    end
  end

  def test_each
    map = new_map

    map.attach(:conn_a, 10)
    map.attach(:conn_b, 20)

    expected = [
      {conn: :conn_a, id: 10},
      {conn: :conn_b, id: 20}
    ]

    i = 0
    map.each do |conn, player_id|
      assert_equal(expected[i][:conn], conn)
      assert_equal(expected[i][:id], player_id)
      i += 1
    end
  end

  private
  def new_map
    Server::ConnectionMap.new(logger: Logger.new(IO::NULL))
  end
end
