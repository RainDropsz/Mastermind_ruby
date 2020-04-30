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
    
    puts "Sorry, you didn't guess the secret code: #{@code}"
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
    @valid_guesses = "123456789"    
    @current_guess = [rand_digit, rand_digit, rand_digit]
    @guess_array = Array.new(2, @current_guess.join(""))
    @correct_array = Array.new(13,0)
    @misplaced_array = Array.new(13,0)    
    @perfect_spot = "01"
    @found_all_digits = false
    @max_perfect = 0
  end


  def guess(i)    
    if i > 1
      num_correct = @correct_array[i-1].to_i
      num_misplaced = @misplaced_array[i-1].to_i

      if num_correct + num_misplaced == 0 
        @valid_guesses = @valid_guesses.delete(@guess_array[i-1])
      elsif num_correct + num_misplaced == 3 
        @valid_guess = @guess_array[i-1]
        @found_all_digits = true
      end

      #find index with most perfects, hold # perfect constant
      index_of_max = @correct_array[1..-1].index(@correct_array[1..-1].max) + 1
      @max_perfect = @correct_array[1..-1].max
      most_perfect_guess = @guess_array[index_of_max]

      if @correct_array[i-1] != @max_perfect
        @perfect_spot = next_try
      end

      while true   
        if @found_all_digits
          @current_guess = @guess_array[i-1].split("").shuffle
        elsif @max_perfect == 1
          @current_guess = [rand_digit, rand_digit, rand_digit]      
          @current_guess[@perfect_spot[0].to_i] = most_perfect_guess[@perfect_spot[0].to_i]
        elsif @max_perfect == 2
          @current_guess = [rand_digit, rand_digit, rand_digit]
          @current_guess[@perfect_spot[0].to_i] = most_perfect_guess[@perfect_spot[0].to_i]
          @current_guess[@perfect_spot[1].to_i] = most_perfect_guess[@perfect_spot[1].to_i]
        elsif @misplaced_array[i-1] >= 1
          temp_array = @guess_array[i-1].split("")
          @current_guess = [ temp_array[1], temp_array[2], temp_array[0] ]
        else
          @current_guess = [rand_digit, rand_digit, rand_digit]
        end

        if ! @guess_array.include?(@current_guess.join("")) 
          break
        end
      end
    end
    @guess_array[i] = @current_guess.join("")
  end

  def question_spot
    "012".delete(@perfect_spot).to_i
  end

  def next_try
    array = ["12","20","01"]
    array [(array.index(@perfect_spot) + 1) % 3]
  end

  def rand_digit
    @valid_guesses[ rand( @valid_guesses.length ) ] 
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
