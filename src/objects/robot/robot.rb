# index が進むかどうかは robot のメソッドで判定する
# RobotInterface にて index が進むかの判定メソッドを Command クラスから使えるようにする方がよさそう

require_relative './command.rb'
require_relative './errors.rb'
require_relative './../../struct/pos.rb'

module Objects
  module Robot
    class Robot

      LOOP_COMMAND_REGEX = /loop\(([1-9]+)([0-9]*)\)/.freeze
      GO_FRONT_REGEX = /go_front/
      GO_BACK_REGEX = /go_back/
      TURN_RIGHT_REGEX = /turn_right/
      TURN_LEFT_REGEX = /turn_left/
      END_REGEX = /end/

      module Dir
        FRONT = 0
        RIGHT = 1
        BACK = 2
        LEFT = 3
      end

      module Icon
        FRONT = 'A'
        RIGHT = '>'
        BACK = '<'
        LEFT = 'V'
      end

      attr_reader :pos, :icon

      def initialize(input, field_controller, pos: Pos.new, direction: Dir::FRONT)
        @commands = parse(input)
        @field_controller = field_controller
        @pos = pos
        @direction = direction
        @icon = update_icon
      end

      def update
        begin
          action_command = @commands.get_movable_command
          process_next_action(action_command)
          update_commands_index(action_command)
          update_icon
        rescue ReachLastCommand
          puts 'プログラムを終了します'
          exit
        end
      end

      private
      def parse(input)
        Command::Block.new(_parse(input), is_outermost_loop: true)
      end

      # arg: raw_string
      # ret: command::block instance
      def _parse(input)
        commands = []
        idx = 0
        while idx < input.length
          case input[idx]
          when GO_FRONT_REGEX
            commands << Command::GoFront.new
            idx += 1
          when GO_BACK_REGEX
            commands << Command::GoBack.new
            idx += 1
          when TURN_RIGHT_REGEX
            commands << Command::TurnRight.new
            idx += 1
          when TURN_LEFT_REGEX
            commands << Command::TurnLeft.new
            idx += 1
          when LOOP_COMMAND_REGEX
            child_loop_number = input[idx].slice(/([0-9]+)/).to_i
            child_input = input[(idx + 1)..-1]
            child_block = Command::Block.new(_parse(child_input), loop_number: child_loop_number)
            commands << child_block
            idx += child_block.size
          when END_REGEX
            break
          else
            raise CommandSyntaxError
          end
        end
        return commands
      end

      # 動作が定義されているコマンドを再帰的に探索し実行する
      def process_next_action(action_command)
        case action_command
        when Command::GoFront, Command::GoBack
          move_to(next_pos(action_command))
        when Command::TurnRight
          turn_right
        when Command::TurnLeft
          turn_left
        end
      end

      def update_commands_index(action_command)
        case action_command
        when Command::GoFront, Command::GoBack
          case @field_controller.at(next_pos(action_command))
          when Field::Wall
            @commands.update_index
          else
            # skip
          end
        when Command::TurnRight, Command::TurnLeft
          @commands.update_index
        else
          binding.pry
          raise CommandSyntaxError # 動作が登録されていないコマンド
        end
      end

      def next_pos(command)
        case command
        when Command::GoFront
          case @direction
          when Dir::FRONT
            Pos.new(x: @pos.x, y: @pos.y - 1)
          when Dir::RIGHT
            Pos.new(x: @pos.x + 1, y: @pos.y)
          when Dir::BACK
            Pos.new(x: @pos.x, y: @pos.y + 1)
          when Dir::LEFT
            Pos.new(x: @pos.x - 1, y: @pos.y)
          end
        when Command::GoBack
          case @direction
          when Dir::FRONT
            Pos.new(x: @pos.x, y: @pos.y + 1)
          when Dir::RIGHT
            Pos.new(x: @pos.x - 1, y: @pos.y)
          when Dir::BACK
            Pos.new(x: @pos.x, y: @pos.y - 1)
          when Dir::LEFT
            Pos.new(x: @pos.x + 1, y: @pos.y)
          end
        when Command::TurnRight, Command::TurnLeft
          @pos
        end
      end

      def move_to(next_pos)
        @pos = next_pos if @field_controller.in_field?(next_pos)
      end

      def turn_right
        case @direction
        when Dir::FRONT
          @direction = Dir::RIGHT
        when Dir::RIGHT
          @direction = Dir::BACK
        when Dir::BACK
          @direction = Dir::LEFT
        when Dir::LEFT
          @direction = Dir::FRONT
        end
      end

      def turn_left
        case @direction
        when Dir::FRONT
          @direction = Dir::LEFT
        when Dir::RIGHT
          @direction = Dir::FRONT
        when Dir::BACK
          @direction = Dir::RIGHT
        when Dir::LEFT
          @direction = Dir::BACK
        end
      end

      def update_icon
        case @direction
        when Dir::FRONT
          @icon = Icon::FRONT
        when Dir::RIGHT
          @icon = Icon::RIGHT
        when Dir::BACK
          @icon = Icon::BACK
        when Dir::LEFT
          @icon = Icon::LEFT
        end
      end
    end
  end
end
