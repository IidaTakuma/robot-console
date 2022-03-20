require_relative './base.rb'

module Render
  class Game < Base

    FIELD_TOP_LINE_Y = 3
    FIELD_LEFT_LINE_X = 4

    def draw_field(len_x, len_y)
      draw_rectangle(
        FIELD_LEFT_LINE_X,
        FIELD_LEFT_LINE_X + (len_x * 2) + 1,
        FIELD_TOP_LINE_Y,
        FIELD_TOP_LINE_Y + len_y + 1
      )
    end

    def draw_object_icon(x, y, icon)
      draw(y + FIELD_TOP_LINE_Y + 1, (x * 2) + FIELD_LEFT_LINE_X + 1, icon)
    end
  end
end
