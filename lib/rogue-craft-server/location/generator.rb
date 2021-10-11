class Location::Geneator

  def initialize
    @elevation_noise = Perlin::Generator.new(rand(0..100_000), 1, 1)
    @biome_noise = Perlin::Generator.new(rand(300_000..500_000), 1, 1)
  end

  def generate(start_x, start_y, size_x, size_y)
    chunk = size_x.times.map do |chunk_x|
      size_y.times.map do |chunk_y|
        x = (start_x + chunk_x) / 50.0
        y = (start_y + chunk_y) / 50.0

        elevation = @elevation_noise[x, y]
        biome = @biome_noise[x, y]

        tile(elevation, biome)
      end
    end
  end

  private
  def tile(elevation, biome)
    #water
    if elevation < -0.19
      return {type: :water}
    # beach
    elsif elevation < -0.09
      return {type: :sand}
    end

    # plains
    if elevation < 0.19
      return {type: :grass}
    end

    # hills
    if elevation < 0.6
      return {type: :hill, occupied: true}
    end

    # mountains
    return {type: :mountain, occupied: true}
  end
end
