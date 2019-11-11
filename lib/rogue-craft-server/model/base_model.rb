class Model::BaseModel < Ohm::Model
  include Ohm::Timestamps
  include Ohm::DataTypes
  include Ohm::Validations
end
