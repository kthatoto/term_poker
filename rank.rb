class Rank
  attr_reader :rank

  RANKS = {
    royal_flush:    {name: 'Royal Flush',     payout: 500},
    straight_flush: {name: 'Straight Flush',  payout: 100},
    four_card:      {name: 'Four of a Kind',  payout: 50},
    full_house:     {name: 'Full House',      payout: 20},
    flush:          {name: 'Flush',           payout: 10},
    straight:       {name: 'Straight',        payout: 8},
    three_card:     {name: 'Three of a Kind', payout: 4},
    two_pair:       {name: 'Two Pair',        payout: 3},
    one_pair:       {name: 'One Pair',        payout: 1},
    high_card:      {name: 'High Card',       payout: 0},
  }
  def initialize(cards)
    @cards = cards
    @rank = evaluate
  end

  def name
    RANKS[@rank][:name]
  end

  def payout
    RANKS[@rank][:payout]
  end

  def self.keys
    RANKS.map { |key, _| key }
  end

  private

    def evaluate
      if royal? && flush?
        :royal_flush
      elsif straight? && flush?
        :straight_flush
      elsif four_card?
        :four_card
      elsif full_house?
        :full_house
      elsif flush?
        :flush
      elsif straight?
        :straight
      elsif three_card?
        :three_card
      elsif two_pair?
        :two_pair
      elsif one_pair?
        :one_pair
      else
        :high_card
      end
    end

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
