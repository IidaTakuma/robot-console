require_relative './command.rb'
require_relative './errors.rb'

module Objects
  module Robot
    class Robot

      LOOP_COMMAND_REGEX = /loop\(([1-9]+)([0-9]*)\)/.freeze
      GO_FRONT_REGEX = /go_front/
      GO_BACK_REGEX = /go_back/
      TURN_RIGHT_REGEX = /turn_right/
      TURN_LEFT_REGEX = /turn_left/
      END_REGEX = /end/

      def initialize(input)
        @commands = parse(input)
        @command_index = 0
      end

      def update
        raise ReachLastCommand if @command_index >= @commands.length

        talk(@commands[@command_index].call)
        update_command_index(@commands[@command_index])
      end

      private
      def parse(input)
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
            child_block = Command::Block.new(parse(child_input), loop_number: child_loop_number)
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

      def talk(command)
        message = case command
                  when Command::GoFront
                    '前へ進む'
                  when Command::GoBack
                    '後ろへ下がる'
                  when Command::TurnRight
                    '右へ回る'
                  when Command::TurnLeft
                    '左へ回る'
                  else
                    '不正なコマンドです'
                  end
        puts message
      end

      def update_command_index(command)
        case command
        when Command::GoFront, Command::GoBack, Command::TurnRight, Command::TurnLeft
          @command_index += 1
        when Command::Block
          @command_index += 1 if command.increment_outer_index?
        else
          binding.pry
          raise CommandSyntaxError
        end

        if @command_index == @commands.length
          binding.pry
          raise ReachLastCommand
        end
      end
    end
  end
end
