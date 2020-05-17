# Digits for ComputerSolver
class Digit
  attr_reader :available_digits

  def initialize
    @available_digits = '123456789'
  end

  def random_digit
    @available_digits.split('').sample
  end

  def include?(guess_digit)
    @available_digits.include?(guess_digit)
  end

  def del_digit(digit)
    @available_digits = @available_digits.delete(digit)
  end
end

