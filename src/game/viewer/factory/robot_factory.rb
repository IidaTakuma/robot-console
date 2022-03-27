require_relative './errors.rb'
require_relative './../charactor/robot/controller.rb'

module Game
  module Viewer
    class RobotFactory
      def initialize(file_path: nil)
        raise ConfigFileNotFound if file_path.nil?

        @file_path = file_path
      end

      def create(stage_controller)
        begin
          file = File.open(@file_path)
          raw_string = file.read
        rescue
          raise ConfigFileNotFound
        end
        Charactor::Robot::Controller.new(raw_string, stage_controller)
      end
    end
  end
end
