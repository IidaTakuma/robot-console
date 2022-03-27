require_relative './field/wall.rb'
require_relative './field/stone.rb'
require_relative './field/goal.rb'

module Game
  class Stage

    attr_reader :size_x, :size_y, :start_pos, :start_direction, :field_objects, :charactors

    def initialize(size_y, size_x, start_pos, start_direction, goal_pos, field_objects)
      @size_y = size_y
      @size_x = size_x
      @start_pos = start_pos
      @start_direction = start_direction
      @goal_pos = goal_pos
      @field_objects = field_objects
      @charactors = []
    end

    def update
      @charactors.each { |charactor| charactor.update }
    end

    def register_charactor(charactor)
      @charactors << charactor
    end

    def at(pos)
      return Field::Wall.new unless in_field?(pos)

      @field_objects.each do |object|
        return object if pos.y == object.pos.y && pos.x == object.pos.x
      end
      nil
    end

    def in_field?(pos)
      (0 <= pos.x && pos.x < @size_x) && (0 <= pos.y && pos.y < @size_y)
    end
  end
end
