# frozen_string_literal: true

# Array of Computer Guesses
class ComputerGuesses
  def initialize
    @guesses = [0]
    @perfect = [0]
    @misplaced = [0]
    @digits = [Digit.new, Digit.new, Digit.new]
    @perfect_spot = '012'
  end

  def guess(guess_number)
    calc_prev_result

    20.times do
      @guesses[guess_number] = random_guess
      keep_or_shuffle
      break if unique?(@guesses[-1]) && digits_valid?(@guesses[-1])
    end

    @guesses[guess_number]
  end

  def calc_prev_result
    delete_digits_not_found
    return unless @perfect[-1] < @perfect.max || @guesses[-1] == @guesses[-2]

    try_next_perfect_spot
  end

  def keep_or_shuffle
    if @perfect[-1] + @misplaced[-1] == 3
      shuffle_all
    elsif @perfect.max >= 1
      keep_perfect_spot(@perfect.max)
    elsif @misplaced[-1] == 2
      shuffle_all
    end
  end

  def keep_perfect_spot(num)
    @guesses[-1][@perfect_spot[0].to_i] =
      most_perfect_guess[@perfect_spot[0].to_i]
    return if num == 1

    @guesses[-1][@perfect_spot[1].to_i] =
      most_perfect_guess[@perfect_spot[1].to_i]
  end

  def shuffle_all
    @guesses[-1] = @guesses[-2].split('').shuffle.join('')
  end

  def read(score)
    @perfect << score.perfect
    @misplaced << score.misplaced
  end

  def digits_valid?(this_guess)
    @digits[0].include?(this_guess[0]) &&
      @digits[1].include?(this_guess[1]) &&
      @digits[2].include?(this_guess[2])
  end

  def try_next_perfect_spot
    array = %w[012 120 201]
    array[2] = array.shift until array.index(@perfect_spot) == 2
    @perfect_spot = array[0]
  end

  def unique?(guess)
    !@guesses[0..-2].include?(guess)
  end

  def most_perfect_guess
    if @perfect.max.positive?
      @guesses[@perfect.index(@perfect.max)].to_s
    else
      random_guess
    end
  end

  def random_guess
    @digits[0].random_digit + @digits[1].random_digit + @digits[2].random_digit
  end

  def delete_digits_not_found
    return if @guesses.length <= 2

    del_from_one_digit if @perfect[-1].zero?
    del_from_all_digit if (@perfect[-1] + @misplaced[-1]).zero?
  end

  def del_from_all_digit
    @digits[0].del_digit(@guesses[-1])
    @digits[1].del_digit(@guesses[-1])
    @digits[2].del_digit(@guesses[-1])
  end

  def del_from_one_digit
    @digits[0].del_digit(@guesses[-1][0])
    @digits[1].del_digit(@guesses[-1][1])
    @digits[2].del_digit(@guesses[-1][2])
  end
end
