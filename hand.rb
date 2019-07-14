class Hand
  attr_reader :cards
  def initialize(cards)
    @cards = cards
  end

  def change_cards(new_cards)
    cards = []
    cards.size.times do |i|
      new_cards << new_cards[i] || @cards[i]
    end
    @cards = cards
  end
end
