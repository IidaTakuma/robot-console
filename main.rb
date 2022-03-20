require 'pry'
require 'curses'
require_relative './src/objects/robot/robot.rb'
require_relative './src/field/controller.rb'
require_relative './src/field/stone.rb'
require_relative './src/field/goal.rb'
require_relative './src/scene/game.rb'

WINDOW_HEIGHT = 17
WINDOW_WIDTH = 51

def main

  # commands = ['go_front', 'loop(3)', 'go_back', 'go_front' 'loop(2)', 'turn_right', 'go_front', 'turn_left', 'end', 'end']
  commands = ['turn_left', 'loop(3)', 'go_front', 'turn_right', 'end', 'go_front', 'turn_left', 'go_front','turn_right', 'go_front']
  field_controller = Field::Controller.new(size_x: 9, size_y: 9)
  robot = Objects::Robot::Robot.new(commands, field_controller, pos: Pos.new(x: 5, y: 5))

  Curses.init_screen
  Curses.crmode
  Curses.noecho
  Curses.stdscr.keypad = true

  window = Curses::Window.new(WINDOW_HEIGHT, WINDOW_WIDTH, 0, 2)
  game_scene = Scene::Game.new(window, field_controller)

  # field object の登録
  stones = [
    Field::Stone.new(Pos.new(x: 3, y: 0)),
    Field::Stone.new(Pos.new(x: 7, y: 3)),
    Field::Stone.new(Pos.new(x: 2, y: 4)),
    Field::Stone.new(Pos.new(x: 6, y: 8))
  ]

  stones.each do |stone|
    field_controller.register(stone)
  end

  field_controller.register(Field::Goal.new(Pos.new(x: 6, y: 7)))

  # game object の登録
  game_scene.register(robot)
  while true
    game_scene.update
    sleep(0.2)
  end
end

if __FILE__ == $0
  main
end
