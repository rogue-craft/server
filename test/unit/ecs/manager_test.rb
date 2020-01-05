require_relative '../test'

class WorldTest < MiniTest::Test

  def test_happy_path
    second_system = mock
    both_supporting_system = mock
    none_supporting_sytem = mock

    world = ECS::World.new(ecs_systems: [second_system, both_supporting_system, none_supporting_sytem], logger: Logger.new(IO::NULL))

    entity_first = world.add_player(11)
    entity_second = world.add_player(12)

    second_system.expects(:supports?).with(entity_first).returns(false)
    second_system.expects(:supports?).with(entity_second).returns(true)

    second_system.expects(:process).with(entity_second)

    both_supporting_system.expects(:supports?).with(entity_first).returns(true)
    both_supporting_system.expects(:supports?).with(entity_second).returns(true)

    both_supporting_system.expects(:process).with(entity_first)
    both_supporting_system.expects(:process).with(entity_second)

    none_supporting_sytem.expects(:supports?).times(2).returns(false)

    none_supporting_sytem.expects(:process).never

    world.update
  end
end
