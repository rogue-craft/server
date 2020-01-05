class Model::Movement < Model::BaseModel

  attribute :speed, Type::Float
  attribute :x, Type::Float
  attribute :y, Type::Float
  attribute :updated_at, Type::Float

  def save
    self.updated_at = Time.now_ms
    super
  end
end
