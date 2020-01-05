require_relative '../test'

class EntityTest < MiniTest::Test

  class TestComponent
  end

  def test_entity
    component = TestComponent.new
    entity = ECS::Entity.new

    entity.add(component)
    assert(entity.has?(TestComponent))
    assert_same(component, entity.get(TestComponent))

    entity.remove(TestComponent)
    assert(false == entity.has?(TestComponent))

    assert_raises(KeyError) do
      entity.get(TestComponent)
    end
  end

  def test_duplicate
    entity = ECS::Entity.new

    entity.add(TestComponent.new)

    err = assert_raises(ArgumentError) do
      entity.add(TestComponent.new)
    end

    assert_equal('Component EntityTest::TestComponent is already set', err.message)
  end

  def test_get_movement
    entity = ECS::Entity.new

    assert(false == entity.has_movement?)
    assert_raises(KeyError) do
      entity.movement
    end

    movement = ECS::Component::Movement.new(nil)
    entity.add(movement)

    assert(entity.has_movement?)
    assert_same(movement, entity.movement)
  end
end
