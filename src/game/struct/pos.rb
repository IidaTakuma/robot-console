module Game
  class Pos
    attr_reader :y, :x
    def initialize(y, x)
      @y = y
      @x = x
    end

    def equal?(other)
      return false unless other.is_a?(Pos)
      return true if other.x == @x && other.y == @y
      false
    end
  end
end
