require_relative './../../base/view.rb'

module Game
  module Viewer
    class View
      include Base::View

      SCALE_Y = 1
      SCALE_X = 2

      def initialize(window)
        @window = window
      end

      def render(stage)
        init_window
        render_stage(stage)
        refresh_window
      end

      private
      def render_stage(stage)
        stage.field_objects.each { |object| draw_icon_in_stage(object) }
        stage.charactors.each { |object| draw_icon_in_stage(object) }
      end

      def draw_icon_in_stage(object)
        draw(object.pos.y * SCALE_Y, object.pos.x * SCALE_X, object.icon)
      end
    end
  end
end
