require_relative './../base/view.rb'

module Game
  class View
    include Base::View
    def initialize(window)
      @window = window
    end

    def render
      draw_sub_win_frame
      @window.refresh
    end

    private
    def draw_sub_win_frame
      draw_rectangle(STAGE_SIZE_Y + 1, STAGE_SIZE_X + 1, STAGE_TOP - 1, STAGE_LEFT - 3)
    end
  end
end
