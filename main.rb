require 'term_canvas'
require_relative './deck'
require_relative './card'
require_relative './hand'
require_relative './expectations'

scene = :betting
betting_dollars = 0
dollars = 100
active_cards_flag = Array.new(5).fill(false)
cursor = 0
deck = Deck.new
hand = nil
showing_expectations = false
expectations = nil

field = TermCanvas::Canvas.new(x: 0, y: 0, w: TermCanvas.width, h: TermCanvas.height)
loop do
  key = TermCanvas.gets
  case key
  when ?q
    break
  end
  if scene == :betting
    case key
    when ?k
      if dollars > 0
        betting_dollars += 1
        dollars -= 1
      end
    when ?K
      if dollars >= 5
        betting_dollars += 5
        dollars -= 5
      elsif dollars > 0
        betting_dollars += dollars
        dollars = 0
      end
    when ?j
      if betting_dollars > 0
        betting_dollars -= 1
        dollars += 1
      end
    when ?J
      if betting_dollars >= 5
        betting_dollars -= 5
        dollars += 5
      elsif dollars > 0
        dollars += betting_dollars
        betting_dollars = 0
      end
    when ?h
      betting_dollars = dollars = (betting_dollars + dollars) / 2
    when ?m
      betting_dollars += dollars
      dollars = 0
    when ?0
      dollars += betting_dollars
      betting_dollars = 0
    when 10
      if betting_dollars > 0
        scene = :playing
        deck = Deck.new
        deck.shuffle
        hand = Hand.new(deck.draw(5))
        expectations = Expectations.new(cards: hand.cards, deck: deck)
      end
    end
  elsif scene == :playing
    case key
    when ?h
      cursor -= 1 if cursor > 0
    when ?l
      cursor += 1 if cursor < 4
    when ?e
      showing_expectations = !showing_expectations
    when ' '
      active_cards_flag[cursor] = !active_cards_flag[cursor]
      active_cards = active_cards_flag.map.with_index { |flag, i|
        hand.cards[i] if !flag
      }.compact
      expectations = Expectations.new(cards: active_cards, deck: deck)
    when 10
      new_cards = active_cards_flag.map.with_index do |flag, i|
        deck.draw if flag
      end
      hand.change_cards(new_cards)
      active_cards_flag.fill(false)
      scene = :result
    when ?e
    end
  elsif scene == :result
    case key
    when 10
      dollars +=  hand.rank.payout * betting_dollars if hand.rank.payout > 0
      betting_dollars = 0
      scene = :betting
    end
  end

  field.clear

  field.text(
    TermCanvas::Text.new(
      x: 2, y: 1, body: "   Chip: $#{dollars}",
      background_color: {r: 0, g: 0, b: 0}, foreground_color: {r: 1000, g: 1000, b: 1000},
    )
  )
  betting_color = scene == :betting ? {r: 300, g: 300, b: 800} : {r: 0, g: 0, b: 0}
  field.text(
    TermCanvas::Text.new(
      x: 2, y: 2, body: "Betting: $#{betting_dollars}",
      background_color: betting_color, foreground_color: {r: 1000, g: 1000, b: 1000},
    )
  )

  if scene == :betting
    5.times do |i|
      patterns = ['┏┓', '┗┛']
      2.times do |j|
        field.text(
          TermCanvas::Text.new(
            x: 2 + i * 3, y: 5 + j, body: patterns[j],
            background_color: {r: 1000, g: 1000, b: 1000},
            foreground_color: {r: 0, g: 0, b: 800},
          )
        )
      end
    end
  elsif scene == :playing || scene == :result
    hand.cards.each_with_index do |card, i|
      color = card.black? ? {r: 0, g: 0, b: 0} : {r: 1000, g: 0, b: 0}
      y = active_cards_flag[i] ? 4 : 5
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
        x: 18, y: 4, body: "Rank: #{hand.rank.name}",
        background_color: {r: 0, g: 0, b: 0}, foreground_color: {r: 1000, g: 1000, b: 1000},
      )
    )
    field.text(
      TermCanvas::Text.new(
        x: 18, y: 5, body: "Payout: $#{betting_dollars} * #{hand.rank.payout}",
        background_color: {r: 0, g: 0, b: 0}, foreground_color: {r: 1000, g: 1000, b: 1000},
      )
    )
    if scene == :playing
      field.text(
        TermCanvas::Text.new(
          x: 2 + cursor * 3, y: 8, body: "🔼",
          background_color: {r: 0, g: 0, b: 0}, foreground_color: {r: 0, g: 0, b: 0},
        )
      )
      field.text(
        TermCanvas::Text.new(
          x: 18, y: 7, body: "(e)xpectation",
          background_color: {r: 0, g: 0, b: 0}, foreground_color: {r: 1000, g: 1000, b: 1000},
        )
      )
      if showing_expectations
        expectations.expectations.each_with_index do |_expectation, i|
          expectation = _expectation[1]
          body = "#{expectation[:name].rjust(15)}: #{format("%.3f", expectation[:probability]).rjust(7)}% *#{expectation[:payout]}"
          field.text(
            TermCanvas::Text.new(
              x: 18, y: 8 + i, body: body,
              background_color: {r: 0, g: 0, b: 0},
              foreground_color: {r: 1000, g: 1000, b: 1000},
            )
          )
        end
      end
    elsif scene == :result
      if hand.rank.payout > 0
        body = "You won $#{hand.rank.payout * betting_dollars}!"
        background_color = {r: 300, g: 300, b: 800}
      else
        body = "You lost..."
        background_color = {r: 0, g: 0, b: 0}
      end
      field.text(
        TermCanvas::Text.new(
          x: 18, y:6, body: body,
          background_color: background_color, foreground_color: {r: 1000, g: 1000, b: 1000},
        )
      )
    end
  end
  field.update
  sleep 0.1
end
TermCanvas.close
