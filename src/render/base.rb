module Render
  class Base

    SCALE_X = 1
    SCALE_Y = 1

    def initialize(window)
      @window = window
    end

    def init_window
      @window.clear
      @window.box('|', '-')
    end

    def refresh_window
      @window.refresh
      Curses.refresh
    end

    def draw_rectangle(left_x, right_x, top_y, bottom_y)
      # 縦線を描画
      (top_y..bottom_y).each do |y|
        draw(y, left_x, '|')
        draw(y, right_x, '|')
      end

      # 横線を描画
      (left_x..right_x).each do |x|
        draw(top_y, x, '-')
        draw(bottom_y, x, '-')
      end

      # 四隅を描画
      draw(top_y, left_x, '┌')
      draw(top_y, right_x, '┐')
      draw(bottom_y, left_x, '└')
      draw(bottom_y, right_x, '┘')
  end

    def draw(y, x, char)
      @window.setpos(y * SCALE_Y, x * SCALE_X)
      @window.addstr(char)
    end

    def calc_center_x_of_text(text)
      ((@window.maxx / 2).round - (text.length / 2).round).round
    end
  end
end
