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
      @graphics = Graphics.new
      @window = @graphics.create_window
    else # do not use curses debug mode
      require_relative './src/debugger/mock_window.rb'
      @window = MockWindow.new
    end
  end

  def process
    while true
      case @destination
      when Destination::MENU
        # pass
      when Destination::GAME
        Game::Controller.new(@window).process
      end
    end
  end
end

if __FILE__ == $0
  if ARGV[0] == '--debug'
    ENV['DEVELOP'] = '1'
  end
  Main.new.process
end
