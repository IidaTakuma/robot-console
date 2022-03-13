require 'pry'
require_relative './src/objects/robot/robot.rb'
require_relative './src/field/controller.rb'

def main
  field_controller = Field::Controller.new(size_x: 9, size_y: 9)
  commands = ['go_front', 'loop(3)', 'go_back', 'go_front' 'loop(2)', 'turn_right', 'go_front', 'turn_left', 'end', 'end']
  robot = Objects::Robot::Robot.new(commands, field_controller, pos: Pos.new(x: 4, y: 4))
  field_controller.register(robot)
  while true
    robot.update
    field_controller.debug
  end
end

if __FILE__ == $0
  main
end
