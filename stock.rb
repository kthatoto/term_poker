class Stock
  attr_reader :cards
  def initialize
    @cards = %w(♠ ♥ ♣ ♦).map { |suit|
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
    raise if !n.is_a? Integer
    @cards.pop(n)
  end
end
