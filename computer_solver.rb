# frozen_string_literal: true

# Computer_solver option
class ComputerSolver < Mastermind
  def initialize
    print_welcome

    @secret_code = gets_code
    @computer_guesses = ComputerGuesses.new

    play_game
  end

  private

  def gets_code(code = '')
    until code =~ /[1-9]{3}/
      puts 'Choose 3 numbers between 1-9.'
      code = gets.chomp[0..2]
    end
    code
  end

  def play_game(winner = false)
    1.upto(12) do |i|
      guess = @computer_guesses.guess(i)
      score = Score.new(guess, @secret_code)
      @computer_guesses.read(score)
      score.print
      break if (winner = score.perfect == 3)
    end

    print_win_or_lose(winner)
    Mastermind.new
  end

  def print_welcome
    puts 'Enter your secret code for the Computer to guess!'
  end
end
