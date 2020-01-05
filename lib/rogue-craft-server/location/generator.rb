class Location::Geneator

  def initialize
    @elevation_noise = Perlin::Generator.new(rand(0..100_000), 1, 1)
  end

  def generate(start_x, start_y, size_x, size_y)
    chunk = size_x.times.map do |chunk_x|
      size_y.times.map do |chunk_y|
        x = start_x + chunk_x
        y = start_y + chunk_y

        elevation = @elevation_noise[x, y]
      end
    end
  end

  private
  def type_of(elevation)
    if e < -0.19
      return ' '.on_blue
    # beach
    elsif e < -0.09
      return ' '.on_yellow
    end

    # plains
    if e < 0.19
      return ' '.on_white
    end

    # forest
    if e < 0.6
      return ' '.on_green
    end

    # hills
    return ' '.on_red
  end
end
