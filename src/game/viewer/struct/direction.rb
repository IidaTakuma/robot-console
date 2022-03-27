module Game
  class Direction
    attr_reader :value

    FRONT = 0
    RIGHT = 1
    BACK = 2
    LEFT = 3

    def initialize(value: 0)
      @value = value
    end

    def turn_right
      @value = (@value + 1) % 4
      nil
    end

    def turn_left
      @value = (@value + 3) % 4
      nil
    end

    def ===(other)
      if other.is_a?(Integer)
        @value == other
      elsif other.is_a?(Direction)
        @value == other.value
      else
        false
      end
    end

    def ==(other)
      if other.is_a?(Integer)
        return @value == other
      elsif other.is_a?(Direction)
        @value == other.value
      else
        false
      end
    end
  end
end
