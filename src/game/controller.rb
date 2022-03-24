require_relative './factory/robot_factory.rb'
require_relative './factory/errors.rb'
require_relative './stage/controller.rb'
require_relative './charactor/controller.rb'
require_relative './struct/pos.rb'
require_relative './struct/direction.rb'

if ENV['DEBUG'].nil?
  require_relative './render.rb'
else
  require_relative './../debugger/game/debug_render.rb'
end

STAGE_FILE_PATH = 'stage.yml'
INPUT_FILE_PATH = 'input.txt'

module Game
  class Controller

    def initialize(window)
      @robot_factory = RobotFactory.new(file_path: INPUT_FILE_PATH)
      @charactor_controller = Charactor::Controller.new
      @stage_controller = Stage::Controller.create_by_config_file(file_path: STAGE_FILE_PATH)
      @robot = @robot_factory.create(@stage_controller)
      @render = Render.new(window)
      @charactor_controller.register(@robot)
    end

    def process
      while true
        @charactor_controller.objects.map(&:update)
        @render.process(@stage_controller, @charactor_controller)
        sleep(0.2)
      end
    end
  end
end
