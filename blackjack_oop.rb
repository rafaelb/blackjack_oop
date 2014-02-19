module User
  def points
    total_points = 0
    @cards.each {|x| total_points += x.points}
    @cards.select{|e| e.value == "A"}.count.times do
      total_points -= 10 if total_points > 21
    end
    total_points
  end

  def hit(card)
    @cards << card
  end

  def print_cards
      @cards.each {|x| puts x.to_s}
      puts "Points: #{points}"
  end
end

class Card
  attr_accessor :suit, :value
  def initialize(s,v)
    @suit = s
    @value = v
  end

  def to_s
    "Suit: #{suit} Card: #{value}"
  end

  def points
    case value
      when '2'..'10'
        value.to_i
      when 'A'
        11
      when 'J', 'Q', 'K'
        10
    end
  end
end

class Deck
  def initialize(num=1)
    @cards = single_deck * num
    @cards.shuffle!
  end

  def single_deck
    cards = []
    ['H','D','S','C'].each do |x|
      ['A','2','3','4','5','6','7','8','9','10','J','Q','K'].each do |y|
        cards << Card.new(x,y)
      end
    end
    cards
  end

  def print
    @cards.each {|x| puts x.to_s}
  end


  def deal
    @cards.pop
  end
end

class Player
  include User
  attr_accessor :name, :cards
  def initialize(name, *cards)
    @name = name
    @cards = cards
  end

  def print
    puts "#{name}'s cards:"
    print_cards
  end

  def hit?
    puts "Press 1 if you want to hit or any other key if you want to stay"
    answer = gets.chomp
    answer == '1'
  end
end

class Dealer
  include User
  def initialize (*cards)
    @cards = cards
  end

  def print
    puts "Dealer's cards:"
    print_cards
  end

  def hit?
    points < 17
  end
end

class Game
  def initialize
  end

  def run
    set_deck
    @turns = 0
    play
    check_winner
  end

  private

  def set_deck
    puts "How many decks of cards should be used?"
    num = gets.chomp
    @deck = Deck.new(num.to_i)
    load_player
    load_dealer
  end

  def play
    result = 0
    result = turn while result < 21
  end

  def check_winner
    puts @player.points == 21 || @dealer.points > 21 ? "#{@player.name} has won!!!" : "Dealer has won!"
  end

  def turn
    @turns += 1
    @turns % 2 == 0 ? dealer_turn : player_turn
  end

  def load_player
    puts "Enter player's name:"
    name = gets.chomp
    @player = Player.new(name,@deck.deal,@deck.deal)
    @player.print
  end

  def load_dealer
    @dealer = Dealer.new(@deck.deal, @deck.deal)
    @dealer.print
  end

  def player_turn
    @player.hit(@deck.deal) if @player.hit?
    @player.print
    @player.points
  end

  def dealer_turn
    @dealer.hit(@deck.deal) if @dealer.hit?
    @dealer.print
    @dealer.points
  end

end

game = Game.new
game.run