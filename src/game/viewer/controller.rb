# 外部ファイルを入力として生成される要素は, Factoryクラスを用いてインスタンスを生成する

require_relative './factory/robot_factory.rb'
require_relative './factory/stage_factory.rb'
require_relative './factory/errors.rb'
require_relative './view.rb'

module Game
  module Viewer
    class Controller
      def initialize(window) # subwinを渡したい
        @stage_factory = StageFactory.new(file_path: ENV['STAGE_FILE_PATH']) # YamlからStageインスタンスを生成する
        @robot_factory = RobotFactory.new(file_path: ENV['INPUT_FILE_PATH']) # ユーザ入力からRobotインスタンスを生成する

        @stage = @stage_factory.create # 障害物の情報を持っている
        @stage.register_charactor(@robot_factory.create(@stage))

        @view = View.new(window)
      end

      def update
        @stage.update
        @view.render(@stage)
      end

      # def receive_signal(sig)
      #   case sig
      #   when Signal::LoadStage, Signal::LoadRobot
      #     load_stage
      #   else
      #     # pass
      #   end
      # end

      private
      def load_stage
        @stage = @stage_factory.create
        @stage.register_charactor(@robot_factory.create)
      end
    end
  end
end
