# frozen_string_literal: true

# Mastermind Game
class Mastermind

  require_relative 'player_solver.rb'
  require_relative 'computer_solver.rb'
  require_relative 'computer_guesses.rb'
  require_relative 'digit.rb'
  require_relative 'score.rb'

  def initialize
    gets_main_menu == '2' ? ComputerSolver.new : PlayerSolver.new
  end

  def gets_main_menu
    puts "Let's Play Mastermind!"
    puts 'Please choose a number:'
    puts '1 - guess the code'
    puts '2 - create the code'
    @option = gets.chomp[0]
  end

  def print_win_or_lose(winner)
    if winner
      puts "\nCongratulations! You guessed the code!\n\n"
    else
      puts "\nSorry, you didn't guess the secret code: #{@secret_code}\n\n"
    end

    puts '----------------------------------------------'
  end
end

Mastermind.new
