require 'pry'
require 'curses'
require_relative './src/objects/robot/robot.rb'
require_relative './src/field/controller.rb'
require_relative './src/scene/game.rb'

def main

  commands = ['go_front', 'loop(3)', 'go_back', 'go_front' 'loop(2)', 'turn_right', 'go_front', 'turn_left', 'end', 'end']

  Curses.init_screen
  Curses.crmode
  Curses.noecho
  Curses.stdscr.keypad = true

  window = Curses::Window.new(0, 0, 0, 0)

  field_controller = Field::Controller.new(size_x: 9, size_y: 9)
  game_scene = Scene::Game.new(window, field_controller)
  robot = Objects::Robot::Robot.new(commands, field_controller, pos: Pos.new(x: 4, y: 4))
  field_controller.register(robot)
  game_scene.register(robot)
  while true
    game_scene.update
    sleep(0.2)
  end
end

if __FILE__ == $0
  main
end
