class Deck
  SUITS = [:spade, :heart, :diamond, :club]
  attr_reader :cards
  def initialize
    @cards = SUITS.map { |suit|
      (1..13).to_a.map { |number|
        Card.new(suit: suit, number: number)
      }
    }.flatten
  end

  def shuffle
    @cards.shuffle!
  end

  def draw(n = nil)
    return @cards.pop if n.nil?
    @cards.pop(n)
  end
end
