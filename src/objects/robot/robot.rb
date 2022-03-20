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
        FRONT = '◢◣'
        RIGHT = ':▶'
        BACK = '◥◤'
        LEFT = '◀:'
        FINISHED_1 = '--'
        FINISHED_2 = '**'
        REACHED_1 = '^^'
        REACHED_2 = '--'
      end

      module Status
        IN_GAME = 0
        PROGRAM_FINISHED = 1
        REACHED_GOAL = 2
      end

      attr_reader :pos, :icon

      def initialize(input, field_controller, pos: Pos.new, direction: Dir::FRONT)
        @commands = parse(input)
        @field_controller = field_controller
        @pos = pos
        @direction = direction
        @status = Status::IN_GAME
        @icon = update_icon
      end

      def update
        case @status
        when Status::IN_GAME
          begin
            movable_command = @commands.get_movable_command
            process_action(movable_command)
            update_commands_index(movable_command)
          rescue ReachLastCommand
            @status = Status::PROGRAM_FINISHED
          end
        when Status::REACHED_GOAL
          # skip
        when Status::PROGRAM_FINISHED
          # skip
        end
        update_icon
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
            idx += child_block.size + 1
          when END_REGEX
            return commands
          else
            raise CommandSyntaxError
          end
        end
        return commands
      end

      # 動作が定義されているコマンドを再帰的に探索し実行する
      def process_action(movable_command)
        case movable_command
        when Command::GoFront, Command::GoBack
          move_to(next_pos(movable_command))
          process_field_event
        when Command::TurnRight
          turn_right
        when Command::TurnLeft
          turn_left
        end
      end

      # 現在いるマスのイベントを処理する
      def process_field_event
        case @field_controller.at(@pos)
        when Field::Goal
          @status = Status::REACHED_GOAL
        else
          # skip
        end
      end

      def update_commands_index(movable_command)
        case movable_command
        when Command::GoFront, Command::GoBack
          case @field_controller.at(next_pos(movable_command))
          when Field::Wall, Field::Stone
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
        @direction = (@direction + 1) % 4
      end

      def turn_left
        @direction = (@direction + 3) % 4
      end

      def update_icon
        case @status
        when Status::IN_GAME
          @icon = case @direction
                  when Dir::FRONT
                    Icon::FRONT
                  when Dir::RIGHT
                    Icon::RIGHT
                  when Dir::BACK
                    Icon::BACK
                  when Dir::LEFT
                    Icon::LEFT
                  end
        when Status::PROGRAM_FINISHED
          @icon = case @icon
                  when Icon::FINISHED_1
                    Icon::FINISHED_2
                  else
                    Icon::FINISHED_1
                  end
        when Status::REACHED_GOAL
          @icon = case @icon
                  when Icon::REACHED_1
                    Icon::REACHED_2
                  else Icon::REACHED_2
                    Icon::REACHED_1
                  end
        end
      end
    end
  end
end
