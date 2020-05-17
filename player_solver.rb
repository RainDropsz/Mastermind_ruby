# frozen_string_literal: true

# Gameplay for player_solver choice
class PlayerSolver < Mastermind
  def initialize
    @secret_code = generate_secret_code
    print_welcome
    play_game
  end

  private

  def winner?(score)
    score.perfect == 3
  end

  def play_game(winner = false)
    1.upto(12) do
      guess = gets.chomp.ljust(3, ' ')[0..2]
      score = Score.new(guess, @secret_code)
      score.print
      break if (winner = score.perfect == 3)
    end

    print_win_or_lose(winner)
    Mastermind.new
  end

  def print_welcome
    puts 'Guess 3 numbers between 1-9.'
    puts 'You have 12 tries.'
    puts '○○○'
  end

  def generate_secret_code
    rand(1..9).to_s + rand(1..9).to_s + rand(1..9).to_s
  end
end
