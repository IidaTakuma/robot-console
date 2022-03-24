module Game
  class Render
    def initialize(window)
      raise TypeError unless window.is_a?(MockWindow)
      puts "== debug render loaded =="
    end

    def process(stage, charactors)
      puts "stage:"
      puts stage.to_yaml
      puts 'charactors:'
      puts charactors.to_yaml

      render_stage(stage, charactors)
    end

    private
    def render_stage(stage, charactors)
      stage.size_y.times do |y|
        stage.size_x.times do |x|
          if obj = charactors.at(Pos.new(y, x))
            print obj.icon
          elsif obj = stage.at(Pos.new(y, x))
            print obj.icon
          else
            print '  '
          end
        end
        print "\n"
      end
    end
  end
end
