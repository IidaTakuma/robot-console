require 'pry'
require_relative './src/objects/robot/robot.rb'

def main
  commands = ['go_front', 'loop(3)', 'go_back', 'loop(2)', 'turn_right', 'turn_left', 'end', 'end']
  robot = Objects::Robot::Robot.new(commands)
  while true
    robot.update
  end
end

if __FILE__ == $0
  main
end
