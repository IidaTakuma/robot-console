class Pos
  attr_reader :x, :y
  def initialize(x: 0, y: 0)
    @x = x
    @y = y
  end

  def equal?(other)
    return false unless other.is_a?(Pos)
    return true if other.x == @x && other.y == @y
    false
  end
end
