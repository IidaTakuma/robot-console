module Game
  module Charactor
    module Robot
      module Command
        class Block
          def initialize(commands, loop_number: 1, is_outermost_loop: false)
            @commands = commands
            @loop_number = loop_number.freeze
            @is_outermost_loop = is_outermost_loop.freeze
            @index = 0
            @loop_count = 0
            @is_increment_outer_index = false
          end

          # arg: none
          # res: Command::Movable
          # memo: Robotに動作が定義されているコマンドに行き着くまで再帰的に探索
          def get_movable_command
            begin
              @commands[@index].get_movable_command
            rescue MovableCommandNotFound
              puts '動作可能なコマンドが見つかりませんでした'
              exit
            end
          end

          # arg: none
          # res: none
          def update_index
            increment_index
            carry_up_loop_count if @index == @commands.length
          end

          # arg: none
          # res: Integer
          # memo: 再帰的にブロックの大きさを取得する
          def size
            res = 0
            @commands.each do |command|
              if command.is_a?(Block)
                res += command.size
              else
                res += 1
              end
            end
            return res + 1
          end

          protected
          def increment_outer_index?
            @is_increment_outer_index
          end

          private
          def increment_index
            child_command = @commands[@index]
            case child_command
            when Movable
              @index += 1
            when Block
              child_command.update_index
              @index += 1 if child_command.increment_outer_index?
            end
          end

          def carry_up_loop_count
            if @index == @commands.length
              @loop_count += 1
              @index = 0
              if @loop_count == @loop_number
                raise ReachLastCommand if @is_outermost_loop

                @is_increment_outer_index = true
                @loop_count = 0
                return
              end
            end
            @is_increment_outer_index = false
          end
        end

        class Movable
          def get_movable_command
            self
          end
        end

        class GoFront < Movable; end
        class GoBack < Movable; end
        class TurnRight < Movable; end
        class TurnLeft < Movable; end
      end
    end
  end
end
