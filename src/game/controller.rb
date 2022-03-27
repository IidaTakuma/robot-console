require_relative './viewer/controller.rb'
require_relative './view.rb'

if ENV['DEBUG'].nil?
  require_relative './../graphics.rb'
else
  require_relative './../debugger/game/debug_render.rb'
end

REFRESH_BOARD_COUNT = 5 # 何フレームごとに盤面を更新するか
TIMEOUT = 20 # 1フレームの時間(msec) ex. 20 => 50fps, 40 => 25fps

module Game
  class Controller

    def initialize(window)
      @window = window
      @viewer_controller = Viewer::Controller.new(@window.subwin(STAGE_SIZE_Y, STAGE_SIZE_X, STAGE_TOP, STAGE_LEFT))
      @view = View.new(@window)
    end

    def process
      frame_count = 0
      loop do
        input = wait_one_frame_for_input(TIMEOUT)
        if input
          case input
          when "\cj" # enter key
            # process
          when "\c?" # backspace key
            # process
          when /^[a-z\(\)]$/
            # process
          else
            # process
          end
        end
        if frame_count >= REFRESH_BOARD_COUNT
          @viewer_controller.update
          frame_count = 0
        end
        # TODO: 画面全体をリフレッシュ
        @view.render
        frame_count += 1
      end
    end

    private
    def wait_one_frame_for_input(timeout)
      begin_timestamp = get_timestamp_msec
      c = wait_input(timeout)
      end_timestamp = get_timestamp_msec
      usleep(delta(begin_timestamp, end_timestamp))
      return c
    end

    def wait_input(timeout)
      @window.timeout = timeout
      begin
        c = @window.get_char
        @input_buffer << c if c
      ensure
        @window.timeout = -1
        return c
      end
    end

    def get_timestamp_msec
      Time.now.strftime('%s%L').to_i
    end

    def delta(from, to)
      return 0 if from >= to

      to - from
    end

    def usleep(msec)
      sleep(msec.to_f / 1000)
    end
  end
end
