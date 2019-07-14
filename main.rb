require 'term_canvas'
require_relative './deck'
require_relative './card'
require_relative './hand'

deck = Deck.new
deck.shuffle
cards = deck.draw(5)

cursor = 0
active_cards = Array.new(5).fill(false)
keys = []

field = TermCanvas::Canvas.new(x: 0, y: 0, w: TermCanvas.width, h: TermCanvas.height)
loop do
  key = TermCanvas.gets
  case key
  when ?q
    break
  when ?h
    cursor -= 1 if cursor > 0
  when ?l
    cursor += 1 if cursor < 4
  when ' '
    active_cards[cursor] = !active_cards[cursor]
  when 10
    active_cards.each_with_index do |flag, i|
      cards[i] = deck.draw if flag
    end
    active_cards.fill(false)
  end
  keys << key if key

  field.clear
  cards.each_with_index do |card, i|
    color = card.black? ? {r: 0, g: 0, b: 0} : {r: 1000, g: 0, b: 0}
    y = active_cards[i] ? 1 : 2
    field.text(
      TermCanvas::Text.new(
        x: 2 + i * 3, y: y, body: card.suit.rjust(2),
        background_color: {r: 1000, g: 1000, b: 1000}, foreground_color: color,
      )
    )
    field.text(
      TermCanvas::Text.new(
        x: 2 + i * 3, y: y + 1, body: card.number.rjust(2),
        background_color: {r: 1000, g: 1000, b: 1000}, foreground_color: color,
      )
    )
  end
  field.text(
    TermCanvas::Text.new(
      x: 2 + cursor * 3, y: 5, body: "🔼",
      background_color: {r: 0, g: 0, b: 0}, foreground_color: {r: 0, g: 0, b: 0},
    )
  )
  field.update
  sleep 0.05
end
TermCanvas.close
# pp keys
