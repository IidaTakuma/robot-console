module Base
  module View

    def initialize(window)
      @window = window
    end

    private
    def init_window
      @window.clear
    end

    def refresh_window
      @window.refresh
      Curses.refresh
    end

    def draw_rectangle(height, width, top, left, vert: '|', hor: '-')

      # 縦線を描画
      height.times do |y|
        draw(top + y, left, vert)
        draw(top + y, left + width, vert)
      end

      # 横線を描画
      width.times do |x|
        draw(top, left + x, hor)
        draw(top + height, left + x, hor)
      end

      # 四隅を描画
      if vert == '|' && hor == '-'
        draw(top, left, '┌')
        draw(top, left + width, '┐')
        draw(top + height, left, '└')
        draw(top + height, left + width, '┘')
      end
    end

    def draw(y, x, char)
      @window.setpos(y, x)
      @window.addstr(char)
    end

    def calc_center_x_of_text(text)
      ((@window.maxx / 2).round - (text.length / 2).round).round
    end
  end
end
