require 'curses'
require_relative './../struct/pos.rb'
require_relative './../render/game.rb'

module Scene
  class Game

    MAP_MARGIN_TOP = 2
    MAP_MARGIN_LEFT = 3

    def initialize(window, field_controller)
      @window = window
      @field_controller = field_controller
      @render = Render::Game.new(@window)
      @objects = []
    end


    def update
      # update each objects
      @objects.each do |obj|
        obj.update
      end

      # render
      @render.init_window
      render_field
      render_objects
      @render.refresh_window
    end

    def register(obj)
      @objects << obj
    end

    def release(obj)
      @objects.delete(obj)
    end

    private
    def render_field
      len_x = @field_controller.size_x
      len_y = @field_controller.size_y

      @render.draw_field(len_x, len_y)

      @field_controller.objects.each do |object|
        @render.draw_object_icon(object.pos.x, object.pos.y, object.icon)
      end
    end

    def render_objects
      @objects.each do |object|
        @render.draw_object_icon(object.pos.x, object.pos.y, object.icon)
      end
    end
  end
end
