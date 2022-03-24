require_relative './../base/render.rb'

module Game
  class Render
    include Base::Render

    SCALE_Y = 1
    SCALE_X = 2

    STAGE_TOP = 4
    STAGE_LEFT = 5

    def process(stage, charactors)
      init_window
      render_stage(stage, charactors)
      refresh_window
    end

    private
    def render_stage(stage, charactors)
      draw_rectangle(
        stage.size_y * SCALE_Y + 1,
        stage.size_x * SCALE_X + 1,
        STAGE_TOP - 1,
        STAGE_LEFT - 1
      )
      stage.objects.each { |obj| draw_icon_in_stage(obj)}
      charactors.objects.each { |obj| draw_icon_in_stage(obj) }
    end

    def draw_icon_in_stage(obj)
      draw(obj.pos.y * SCALE_Y + STAGE_TOP, obj.pos.x * SCALE_X + STAGE_LEFT, obj.icon)
    end
  end
end
