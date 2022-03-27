require 'yaml'
require_relative './errors.rb'
require_relative './../stage.rb'
require_relative './../field/goal.rb'
require_relative './../field/stone.rb'
require_relative './../struct/pos.rb'
require_relative './../struct/direction.rb'

module Game
  module Viewer
    class StageFactory
      def initialize(file_path: nil)
        raise ConfigFileNotFound if file_path.nil?

        @file_path = file_path
      end

      def create(index: 0)
        stages = YAML.load_file(@file_path)
        raise ConfigFileNotFound if stages.nil?

        meta = stages[index]['meta']
        start_pos = Pos.new(meta['start_y'], meta['start_x'])
        start_direction = Direction.new(value: meta['start_direction'])
        goal_pos = Pos.new(meta['goal_y'] - 1, meta['goal_x'] - 1)

        objects = []
        objects << Field::Goal.new(goal_pos)
        datas = stages[index]['objects']
        datas.keys.each do |key|
          datas[key].each do |params|
            objects << Object.const_get("Game::Field::#{key.capitalize}").new(Pos.new(params['y'] - 1, params['x'] - 1))
          end
        end

        Stage.new(
          meta['size_y'],
          meta['size_x'],
          start_pos,
          start_direction,
          goal_pos,
          objects
        )
      end
    end
  end
end
