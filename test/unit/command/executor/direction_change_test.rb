require_relative '../../test'

class DirectionChangeTest < MiniTest::Test

  def test_happy_path
    command = {
      direction: Interpolation::Direction::NORTH
    }

    player = mock
    player.expects(:id).returns(879)

    model = mock

    seq = sequence(:component)

    movement = mock
    movement.expects(:write).yields(movement).in_sequence(seq)
    movement.expects(:model).returns(model).in_sequence(seq)

    model.expects(:update).with(direction: command[:direction]).in_sequence(seq)

    entity = mock
    entity.expects(:movement).returns(movement)

    world = mock
    world.expects(:player).with(879).returns(entity)

    command = {
      direction: Interpolation::Direction::NORTH
    }

    executor = Command::Executor::DirectionChange.new(world: world)
    executor.call(command, player)
  end
end
