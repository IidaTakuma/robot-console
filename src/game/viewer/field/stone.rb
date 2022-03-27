module Game
  module Field
    class Stone
      attr_reader :pos, :icon
      def initialize(pos)
        @pos = pos
        @icon = '[]'
      end
    end
  end
end
