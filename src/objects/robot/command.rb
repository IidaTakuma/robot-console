module Objects
  module Robot
    module Command
      class Block
        def initialize(commands, loop_number: 1)
          @commands = commands
          @loop_number = loop_number.freeze
          @index = 0
          @loop_counter = 0
          @is_increment_outer_index = false
        end

        def call
          next_action = @commands[@index].call # プリミティブなコマンドに行き着くまで再帰的に探索
          update_index(@commands[@index])

          next_action
        end

        def increment_outer_index?
          @is_increment_outer_index
        end

        def size
          # 再帰的にブロックの大きさを取得する
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

        private
        def update_index(command)
          case command
          when GoFront, GoBack, TurnRight, TurnLeft
            @index += 1
          when Block
            @index += 1 if command.increment_outer_index?
          end

          if @index == @commands.length
            @loop_counter += 1
            @index = 0
            if @loop_counter == @loop_number
              @is_increment_outer_index = true
              @index = 0
              @loop_counter = 0
            else
              @is_increment_outer_index = false
            end
          else
            @is_increment_outer_index = false
          end
        end
      end

      class GoFront
        def call
          self
        end
      end

      class GoBack
        def call
          self
        end
      end

      class TurnRight
        def call
          self
        end
      end

      class TurnLeft
        def call
          self
        end
      end
    end
  end
end
