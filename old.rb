=begin
Build a Mastermind game from the command line 
where you have 12 turns to guess the secret code.
=end


class Mastermind
  def initialize
    puts "Let's Play Mastermind!"
    @option = coder_or_guesser?

    print_instructions(@option)
    @code = get_code(@option)

    if @option == "Computer"
      computer_guesses = ComputerGuesses.new
    end

    for i in 1..12 do
      if @option == "Player"
        guess = (gets.chomp.to_s + "000")[0..2]

        score = Score.new
        score.score_guess(guess, @code)
      else 
        guess = computer_guesses.guess(i)

        score = Score.new
        score.score_guess(guess, @code)
        computer_guesses.correct_array[i] = score.correct
        computer_guesses.misplaced_array[i] = score.misplaced
      end

    

      if score.winner?
        puts "Congratulations! You guessed the code!"
        return
      end
    end
    
    puts "Sorry #{@option}, you didn't guess the secret code: #{@code}"
  end

  def get_code(option)
    if option == "Player" 
      code = rand(1..9).to_s + rand(1..9).to_s + rand(1..9).to_s 
    else 
      code = (gets.chomp.to_s + "111")[0..2]
    end
  end

  def print_instructions(option)
    if option == "Player"
      puts "Guess 3 numbers between 1-9."
      puts "You have 12 tries."
      puts "○○○"
    else 
      puts "Enter your secret code!"
      puts "Choose 3 numbers between 1-9."
    end
  end

  def coder_or_guesser?
    puts "Please choose a number:"
    puts "1 - guess the code"
    puts "2 - create the code"
    @option = gets.chomp[0]
    @option == "2" ? @option = "Computer" : @option = "Player"
  end

end

class ComputerGuesses
  attr_reader :guess_array
  attr_accessor :correct_array, :misplaced_array

  def initialize
    @guess_array = []
    @correct_array = []
    @misplaced_array = []    
    @valid_guesses = "123456789"
    @weight = [0,1,1,1,1,1,1,1,1,1]
  end

  def guess(i)    
    num_correct = @correct_array[i-1].to_i
    num_misplaced = @misplaced_array[i-1].to_i

    if num_correct + num_misplaced == 0 && i > 1
      @valid_guesses = @valid_guesses.delete(@guess_array[i-1])
    elsif num_correct + num_misplaced == 3 && i > 1
      return @guess_array[i] = guess_array[i-1].split("").shuffle.join("")
    elsif i > 1
      for guess_array[i-1].split("").each do |c|
        @weight[c.to_i] += 2
      end
    end

    len = @valid_guesses.length
    @guess_array[i] = @valid_guesses[ rand(len) ] +  
                      @valid_guesses[ rand(len) ] +  
                      @valid_guesses[ rand(len) ]
  

  end

end


class Score
  attr_reader :correct, :misplaced  
  def initialize
    @correct = 0
    @misplaced = 0
    @misplaced_search_string = ""
    @guess_not_found = ""
  end

  def score_guess(guess, code)
    for i in 0..2 do 
      if guess[i] == code[i]
        @correct += 1         
      else
        @misplaced_search_string << code[i]
        @guess_not_found << guess[i]
      end
    end

    for i in 0..@guess_not_found.length-1 do
      if @misplaced_search_string.split("").include?(@guess_not_found[i])
        @misplaced += 1
        @misplaced_search_string.sub!(@guess_not_found[i], "0")    
      end
    end

    puts "       #{guess}     Perfect: #{@correct}  Misplaced: #{@misplaced}"  
  end

  def winner?
    @correct == 3  
  end

end 

Mastermind.new
