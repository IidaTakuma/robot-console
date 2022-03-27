require 'pry'
require_relative './src/graphics.rb'
require_relative './src/game/controller.rb'

class Main

  module Destination
    MENU = 0
    GAME = 1
  end

  def initialize
    @destination = Destination::GAME

    if ENV['DEVELOP'].nil?
      @window = Graphics.create_window
    else # do not use curses debug mode
      require_relative './src/debugger/mock_window.rb'
      @window = MockWindow.new
    end
  end

  def process
    begin
      while true
        case @destination
        when Destination::MENU
          # pass
        when Destination::GAME
          Game::Controller.new(@window).process
        end
      end
    ensure
      Curses.close_screen
    end
  end
end


if __FILE__ == $0
  if ARGV[0] == '--debug'
    ENV['DEVELOP'] = '1'
  end
  ENV['STAGE_FILE_PATH'] = 'stage.yml'
  ENV['INPUT_FILE_PATH'] = 'input.txt'
  Main.new.process
end
