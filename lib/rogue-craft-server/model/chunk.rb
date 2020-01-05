class Model::Chunk < Model::BaseModel

  include Ohm::Timestamps

  attr_reader :lock

  SIZE = 50

  attribute :position
  unique :position

  attribute :entities, Type::Hash

  def initialize(args)
    super
    @lock = Concurrent::ReadWriteLock.new
  end

  def self.with_coordinate(x, y)
    with(:position, position_from(x, y))
  end

  def self.position_from(x, y)
    x = (x / SIZE) * SIZE
    y = (y / SIZE) * SIZE

    "#{x}-#{y}"
  end
end
