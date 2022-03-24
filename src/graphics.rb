require 'curses'

WINDOW_HEIGHT = 17
WINDOW_WIDTH = 51

class Graphics
  def initialize
    init_curses
  end

  def create_window
    Curses::Window.new(WINDOW_HEIGHT, WINDOW_WIDTH, 0, 2)
  end

  private
  def init_curses
    Curses.init_screen
    Curses.cbreak
    Curses.noecho
    Curses.stdscr.keypad = true
  end
end
