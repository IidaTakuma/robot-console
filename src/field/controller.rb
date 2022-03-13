require_relative './../struct/pos.rb'
require_relative './wall.rb'

module Field
  class Controller
    def initialize(size_x: 8, size_y: 8)
      @size_x = size_x
      @size_y = size_y
      @objects = []
    end

    def register(object)
      @objects << object
    end

    def release(object)
      @objects.delete(object)
    end

    def at(pos)
      return Wall.new unless in_field?(pos)

      @objects.each do |object|
        return object if pos.x == object.pos.x && pos.y == object.pos.y
      end
      nil
    end

    def in_field?(pos)
      (0 <= pos.x && pos.x < @size_x) && (0 <= pos.y && pos.y < @size_y)
    end

    def debug

      puts '=== start ==='

      @size_y.times do |y|
        @size_x.times do |x|
          if @objects.any? { |object| object.pos.equal?(Pos.new(x: x, y: y)) }
            @objects.each do |object|
              if object.pos.equal?(Pos.new(x: x, y: y))
                print object.icon
                break
              end
            end
          else
            print '・'
          end
        end
        print "\n"
      end

      puts '==== end ===='
    end
  end
end
