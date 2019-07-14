class Card
  SUITS = [:spade, :heart, :diamond, :club]
  def initialize(suit:, number:)
    @suit = suit
    @number = number
    raise if !validate
  end

  def suit
    {spade: ?♠, heart: ?♥, diamond: ?♦, club: ?♣}[@suit]
  end

  def number
    if figure = {'1': ?A, '11': ?J, '12': ?Q, '13': ?K}[@number.to_s.to_sym]
      return figure
    end
    @number.to_s
  end

  def black?
    [:spade, :club].include?(@suit)
  end

  def red?
    [:heart, :diamond].include?(@suit)
  end

  private

    def validate
      return false unless SUITS.include?(@suit)
      return false unless @number.is_a?(Integer) && @number >= 1 && @number <= 13
      true
    end
end
