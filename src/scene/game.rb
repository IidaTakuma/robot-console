require 'curses'
require_relative './../struct/pos.rb'
require_relative './../render/game.rb'

module Scene
  class Game

    MAP_MARGIN_TOP = 3
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
      render_map
      render_frame
      @render.refresh_window
    end

    def register(obj)
      @objects << obj
    end

    def release(obj)
      @objects.delete(obj)
    end

    private
    def render_map
      len_x = @field_controller.size_x
      len_y = @field_controller.size_y

      # 枠線を描画
      @render.draw_rectangle(
        MAP_MARGIN_LEFT - 1,
        MAP_MARGIN_LEFT + len_x,
        MAP_MARGIN_TOP - 1,
        MAP_MARGIN_TOP + len_y
      )

      len_y.times do |x|
        len_x.times do |y|
          if obj = @field_controller.at(Pos.new(x: x, y: y))
            @render.draw(y + MAP_MARGIN_TOP, x + MAP_MARGIN_LEFT, obj.icon)
          else
            @render.draw(y + MAP_MARGIN_TOP, x + MAP_MARGIN_LEFT, ' ')
          end
        end
      end
    end

    def render_frame
    end
  end
end
