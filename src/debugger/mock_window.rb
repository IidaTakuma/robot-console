require_relative './game/debug_render.rb'

class MockWindow
  def initialize
    puts "== debug mode =="
  end
end
