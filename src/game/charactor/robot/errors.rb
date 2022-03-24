module Game
  module Charactor
    module Robot
      class Error < StandardError; end
      class ReachLastCommand < StandardError; end
      class CommandSyntaxError < StandardError; end
      class MovableCommandNotFound < StandardError; end
    end
  end
end
