require_relative 'player'

class Game
  attr_accessor :fragment

  def initialize(player1 = Player.new("Player1"),
                 player2 = Player.new("Player2"))

    @current_player = player1
    @previous_player = player2
    @dictionary = File.readlines('dictionary.txt').map(&:chomp)
    @fragment = ''
    @losses = { player1 => 0,
                player2 => 0 }
  end

  def run
    until @losses.values.include?(2
      )
      display_standings
      play_round
    end

    display_standings
    puts "#{@previous_player.name} loses the game."
  end

  def play_round

    until over?
      take_turn
      next_player!
      #@dictionary.collect! { |word| word =~ /^#{@fragment}/ }
    end

    puts "#{@previous_player.name} loses this round."
    @losses[@previous_player] += 1
    @fragment = ""
  end

  def over?
    if @dictionary.include?(@fragment)
      return true
    end
    false
  end

  def next_player!
    @current_player, @previous_player = @previous_player, @current_player
  end

  def take_turn

    str = @current_player.guess
    until valid_play?(str)
      @current_player.alert_invalid_guess
      str = @current_player.guess
    end
    @fragment += str

  end

  def valid_play?(string)
    return false unless ('a'..'z').to_a.include?(string)

    temp_frag = @fragment + string
    return false unless @dictionary.any? { |word| word =~ /^#{temp_frag}/ }

    true
  end

  def record(num)
    "GHOST"[0...num]
  end

  def display_standings
    @losses.each do |player, loss|
      next if loss.zero?
      puts "#{player.name} has #{record(loss)}."
    end
  end
end


if __FILE__ == $PROGRAM_NAME
  Game.new.run
end
