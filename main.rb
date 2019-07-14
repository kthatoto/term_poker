require 'term_canvas'
require_relative './deck'
require_relative './card'
require_relative './hand'

deck = Deck.new
deck.shuffle
cards = deck.draw(5)

field = TermCanvas::Canvas.new(x: 0, y: 0, w: TermCanvas.width, h: TermCanvas.height)
loop do
  key = TermCanvas.gets
  case key
  when ?q
    break
  end

  field.clear
  cards.each_with_index do |card, i|
    color = card.black? ? {r: 0, g: 0, b: 0} : {r: 1000, g: 0, b: 0}
    field.text(
      TermCanvas::Text.new(
        x: 2 + i * 3, y: 2, body: card.suit.rjust(2),
        background_color: {r: 1000, g: 1000, b: 1000}, foreground_color: color,
      )
    )
    field.text(
      TermCanvas::Text.new(
        x: 2 + i * 3, y: 3, body: card.number.rjust(2),
        background_color: {r: 1000, g: 1000, b: 1000}, foreground_color: color,
      )
    )
  end
  field.update
  sleep 0.05
end
TermCanvas.close
