# コマンドの構造を保持するのみで、indexの更新などは行わない

module Objects
  module Robot
    module Command
      class Block
        def initialize(commands, loop_number: 1, origin: false)
          @commands = commands
          @loop_number = loop_number.freeze
          @index = 0
          @loop_counter = 0
          @is_increment_outer_index = false
          @origin = origin # 一番外側のroopであるか
        end

        def search_movable_action
          begin
          @commands[@index].search_movable_action # コマンドに行き着くまで再帰的に探索
          rescue NoMethodError
            binding.pry
          end
        end

        def update_index
          # 現在実行しているコマンドのindexを1すすめる
          case @commands[@index]
          when GoFront, GoBack, TurnRight, TurnLeft
            @index += 1
          when Block
            @commands[@index].update_index
            @index += 1 if @commands[@index].increment_outer_index?
          end

          if @index == @commands.length
            @loop_counter += 1
            @index = 0
            if @loop_counter == @loop_number
              raise ReachLastCommand if @origin

              @is_increment_outer_index = true
              @loop_counter = 0
            else
              @is_increment_outer_index = false
            end
          else
            @is_increment_outer_index = false
          end
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
      end

      class GoFront
        def search_movable_action
          self
        end
      end

      class GoBack
        def search_movable_action
          self
        end
      end

      class TurnRight
        def search_movable_action
          self
        end
      end

      class TurnLeft
        def search_movable_action
          self
        end
      end
    end
  end
end
