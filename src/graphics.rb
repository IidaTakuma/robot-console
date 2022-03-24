require 'curses'

WINDOW_HEIGHT = 17
WINDOW_WIDTH = 51

class Graphics

  def self.init_curses
    Curses.init_screen
    Curses.cbreak
    Curses.noecho
    Curses.stdscr.keypad = true
  end

  def self.create_window
    Curses::Window.new(WINDOW_HEIGHT, WINDOW_WIDTH, 0, 2)
  end

  def self.close_window
    Curses.close_screen
  end
end
