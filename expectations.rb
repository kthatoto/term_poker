require_relative './rank'
class Expectations
  attr_reader :expectations

  def initialize(cards:, deck:)
    @cards = cards
    @deck = deck
    @rank_count = Rank.keys.map { |key| [key, 0] }.to_h
    @expectations = Rank::RANKS.map { |key, value|
      [key, value.merge({probability: 0.0})]
    }.to_h
    calculate
  end

  def total_calculate
    @expectations.map { |_, value|
      value[:payout] * value[:probability]
    }.inject(:+)
  end

  private

    def calculate
      case @cards.size
      when 5
        rank = Rank.new(@cards)
        @rank_count[rank.rank] += 1
      when 4
        @deck.size.times do |i|
          rank = Rank.new([@cards, @deck.cards[i]].flatten)
          @rank_count[rank.rank] += 1
        end
      when 3
        @deck.size.times do |i|
          (@deck.size - i - 1).times do |j|
            rank = Rank.new([@cards, @deck.cards[i], @deck.cards[i + j + 1]].flatten)
            @rank_count[rank.rank] += 1
          end
        end
      when 2
        @deck.size.times do |i|
          (@deck.size - i - 1).times do |j|
            (@deck.size - i - j - 2).times do |k|
              rank = Rank.new([
                @cards,
                @deck.cards[i],
                @deck.cards[i + j + 1],
                @deck.cards[i + j + k + 2]
              ].flatten)
              @rank_count[rank.rank] += 1
            end
          end
        end
      when 1
        @deck.size.times do |i|
          (@deck.size - i - 1).times do |j|
            (@deck.size - i - j - 2).times do |k|
              (@deck.size - i - j - k - 3).times do |l|
                rank = Rank.new([
                  @cards,
                  @deck.cards[i],
                  @deck.cards[i + j + 1],
                  @deck.cards[i + j + k + 2],
                  @deck.cards[i + j + k + l + 3]
                ].flatten)
                @rank_count[rank.rank] += 1
              end
            end
          end
        end
      when 0
        @deck.size.times do |i|
          (@deck.size - i - 1).times do |j|
            (@deck.size - i - j - 2).times do |k|
              (@deck.size - i - j - k - 3).times do |l|
                (@deck.size - i - j - k - l - 4).times do |m|
                  rank = Rank.new([
                    @deck.cards[i],
                    @deck.cards[i + j + 1],
                    @deck.cards[i + j + k + 2],
                    @deck.cards[i + j + k + l + 3],
                    @deck.cards[i + j + k + l + m + 4]
                  ])
                  @rank_count[rank.rank] += 1
                end
              end
            end
          end
        end
      end

      combination_count = @rank_count.map { |_, count| count }.inject(:+)
      @rank_count.each do |key, count|
        @expectations[key][:probability] = count / combination_count.to_f
      end
    end
end
