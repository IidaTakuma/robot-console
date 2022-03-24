require_relative './robot/controller.rb'

module Game
  module Charactor
    class Controller
      attr_reader :objects
      def initialize
        @objects = []
      end

      def update
        @objects.each { |obj| obj.update }
      end

      def register(obj)
        @objects << obj
      end

      def release(obj)
        @objects.delete(obj)
      end

      def at(pos)
        @objects.each do |object|
          return object if pos.y == object.pos.y && pos.x == object.pos.x
        end
        nil
      end
    end
  end
end
