class Hand
  attr_reader :cards
  def initialize(cards)
    @cards = cards
  end

  def change_cards(new_cards)
    cards = []
    @cards.size.times do |i|
      cards << (new_cards[i] || @cards[i])
    end
    @cards = cards
  end

  def rank
    if royal? && flush?
      'Royal Flush'
    elsif straight? && flush?
      'Straight Flush'
    elsif four_card?
      'Four of a Kind'
    elsif full_house?
      'Full House'
    elsif flush?
      'Flush'
    elsif straight?
      'Straight'
    elsif three_card?
      'Three of a Kind'
    elsif two_pair?
      'Two Pair'
    elsif one_pair?
      'One Pair'
    else
      'High card'
    end
  end

  private

    def numbers
      @cards.map(&:raw_number).sort
    end

    def suits
      @cards.map(&:raw_suit)
    end

    def royal?
      numbers == [1, 10, 11, 12, 13]
    end

    def straight?
      royal? || (numbers.uniq.size == 5 && numbers[-1] - numbers[0] == 4)
    end

    def flush?
      suits.uniq.size == 1
    end

    def full_house?
      numbers.group_by { |n| n }.map { |_, g| g.size }.sort == [2, 3]
    end

    def four_card?
      numbers.group_by { |n| n }.map { |_, g| g.size }.sort == [1, 4]
    end

    def three_card?
      numbers.group_by { |n| n }.map { |_, g| g.size }.sort == [1, 1, 3]
    end

    def two_pair?
      numbers.group_by { |n| n }.map { |_, g| g.size }.sort == [1, 2, 2]
    end

    def one_pair?
      numbers.group_by { |n| n }.map { |_, g| g.size }.sort == [1, 1, 1, 2]
    end
end
