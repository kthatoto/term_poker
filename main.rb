require 'term_canvas'

field = TermCanvas::Canvas.new(x: 0, y: 0, TermCanvas.width, h: TermCanvas.height)

class Card
  def initialize
  end
end

class Hand
end

loop do
  key = TermCanvas.gets
  case key
  when ?q
    break
  end

  cards = Card.draw(5)

  field.clear
  field.update
  sleep 0.05
end
