class Card
  attr_reader :suit, :number
  def initialize(suit:, number:)
    @suit = suit
    @number = number
  end
end
