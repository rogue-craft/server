module Schema::Command
  class DirectionChange < Dry::Schema::Params
    define do
      required(:direction).value(included_in?: Interpolation::Direction.all)
    end
  end

  class Execute < Dry::Validation::Contract
    TYPE_SCHEMAS = {
      direction_change: DirectionChange.new
    }

    params do
      required(:queue)
    end

    rule(:queue) do
      value.each do |command|
        type = command[:type]

        unless TYPE_SCHEMAS.keys.include?(type)
          key.failure("Unknown or no type #{type}")
        else
          errors = TYPE_SCHEMAS[type].call(command).errors

          key.failure(errors.to_h.to_s) unless errors.empty?
        end
      end
    end
  end
end

