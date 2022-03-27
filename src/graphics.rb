require 'curses'

WINDOW_HEIGHT = 17
WINDOW_WIDTH = 51

STAGE_TOP = 4
STAGE_LEFT = 5
STAGE_SIZE_Y = 9
STAGE_SIZE_X = 18

class Graphics

  def self.init_curses
    Curses.init_screen
    # Curses.leaveok
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

  def self.refresh
    Curses.refresh
  end
end
