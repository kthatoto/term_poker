require 'term_canvas'
require_relative './deck'
require_relative './card'
require_relative './hand'

deck = Deck.new
deck.shuffle
hand = Hand.new(deck.draw(5))

cursor = 0
active_cards = Array.new(5).fill(false)

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
    new_cards = active_cards.map.with_index do |flag, i|
      deck.draw if flag
    end
    hand.change_cards(new_cards)
    active_cards.fill(false)
  end

  field.clear
  hand.cards.each_with_index do |card, i|
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

  field.text(
    TermCanvas::Text.new(
      x: 18, y: 2, body: "Deck: #{deck.size}",
      background_color: {r: 0, g: 0, b: 0}, foreground_color: {r: 1000, g: 1000, b: 1000},
    )
  )
  field.text(
    TermCanvas::Text.new(
      x: 18, y: 4, body: "Rank: #{hand.rank}",
      background_color: {r: 0, g: 0, b: 0}, foreground_color: {r: 1000, g: 1000, b: 1000},
    )
  )
  field.update
  sleep 0.05
end
TermCanvas.close
