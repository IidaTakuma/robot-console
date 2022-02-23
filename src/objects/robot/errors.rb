module Objects
  module Robot
    class Error < StandardError; end
    class ReachLastCommand < StandardError; end
    class CommandSyntaxError < StandardError; end
  end
end
