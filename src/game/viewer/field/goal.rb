module Game
  module Field
    class Goal
      attr_reader :pos, :icon
      def initialize(pos)
        @pos = pos
        @icon = '▕≈'
      end
    end
  end
end
