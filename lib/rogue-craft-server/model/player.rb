class Model::Player < Model::BaseModel
  include Ohm::Validations
  include Ohm::SoftDelete

  attribute :nickname
  unique :nickname

  attribute :email
  unique :email

  attribute :token
  unique :token

  attribute :token_expiration, Type::Time

  attribute :activation_code
  unique :activation_code

  attribute :password
  attribute :salt

  def token_expired?
    Time.now >= token_expiration
  end
end
