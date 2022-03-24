require 'yaml'
require_relative './wall.rb'
require_relative './stone.rb'
require_relative './goal.rb'

module Game
  module Stage
    class Controller

      attr_reader :size_x, :size_y, :start_pos, :start_direction, :goal_pos, :objects

      def self.create_by_config_file(file_path: nil, index: 0)
        raise ConfigFileNotFound if file_path.nil?

        stages = YAML.load_file(file_path)
        raise ConfigFileNotFound if stages.nil?

        meta = stages[index]['meta']
        start_pos = Pos.new(meta['start_y'], meta['start_x'])
        start_direction = Direction.new(value: meta['start_direction'])
        goal_pos = Pos.new(meta['goal_y'] - 1, meta['goal_x'] - 1)

        objects = []
        objects << Goal.new(goal_pos)
        datas = stages[index]['objects']
        datas.keys.each do |key|
          datas[key].each do |params|
            objects << Object.const_get("Game::Stage::#{key.capitalize}").new(Pos.new(params['y'] - 1, params['x'] - 1))
          end
        end

        self.new(
          meta['size_y'],
          meta['size_x'],
          start_pos,
          start_direction,
          goal_pos,
          objects
        )
      end

      def initialize(size_y, size_x, start_pos, start_direction, goal_pos, objects)
        @size_y = size_y
        @size_x = size_x
        @start_pos = start_pos
        @start_direction = start_direction
        @goal_pos = goal_pos
        @objects = objects
      end

      def register(obj)
        @objects << obj
      end

      def release(obj)
        @objects.delete(obj)
      end

      def at(pos)
        return Wall.new unless in_field?(pos)

        @objects.each do |object|
          return object if pos.y == object.pos.y && pos.x == object.pos.x
        end
        nil
      end

      def in_field?(pos)
        (0 <= pos.x && pos.x < @size_x) && (0 <= pos.y && pos.y < @size_y)
      end
    end
  end
end
