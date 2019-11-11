module Schema::Auth
  class Registration < Dry::Validation::Contract

    USERNAME_PARAMS = {min_size?: 5, max_size?: 15, format?: /^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$/}
    FORMAT_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    PW_PARAMS = {min_size?: 5, max_size?: 30, format?: /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[\W]).{8,}$/}

    params do
      required(:nickname).value(USERNAME_PARAMS)
      required(:password).value(PW_PARAMS)
      required(:password_confirmation).value(PW_PARAMS)
      required(:email).value(format?: FORMAT_EMAIL)
    end

    rule(:password_confirmation) do
      if values[:password_confirmation] != values[:password]
        key.failure('passwords must be equal')
      end
    end
  end

  class Login < Dry::Validation::Contract
    params do
      required(:nickname).filled
      required(:password).filled
    end
  end

  class Acivation < Dry::Validation::Contract
    params do
      required(:activation_code).value(size?: Handler::Auth::ACTIVATION_CODE_LENGTH * 2)
    end
  end

  class Logout < Dry::Validation::Contract
    params do
    end
  end
end
