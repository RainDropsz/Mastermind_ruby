# Score each Mastermind Guess
class Score
  attr_reader :perfect, :misplaced

  def initialize(guess, secret_code)
    @original_guess = guess
    @guess = guess.dup
    @secret_code = secret_code.dup
    @perfect = count_number_of_perfect
    @misplaced = count_number_of_misplaced
  end

  def count_number_of_perfect(count = 0)
    3.times do |i|
      if @guess[i] == @secret_code[i]
        remove_matched(i)
        count += 1
      end
    end
    count
  end

  def count_number_of_misplaced(count = 0)
    @guess.gsub(' ', '').split('').each_with_index do |c, i|
      if @secret_code.include?(c)
        count += 1
        remove_matched(i, @secret_code.index(c))
      end
    end
    count
  end

  def print
    puts "       #{@original_guess}     " \
         "Perfect: #{@perfect}  Misplaced: #{@misplaced}"
  end

  def remove_matched(guess_index, code_index = guess_index)
    @guess[guess_index] = ' '
    @secret_code[code_index] = ' '
  end
end

