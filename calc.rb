#!/bin/ruby
# More advanced version of the basic calculator, allows you to run it with args and pass in a single mathematical operation
require 'optparse'
require 'logger'

module CalcParser

  # Checks if a given string is a number
  def CalcParser.is_number(string)
    return string.match?(/\d*\.?\d+/)
  end

  # Checks if the string is a operator
  def CalcParser.is_operator(string)
    return string.match?(/[\*\/\+\-\%]/)
  end

  # Check if the string is a square root formula
  def CalcParser.is_sqrt(string)
    return string.match?(/sqrt\(\d*\.?\d+\)/)
  end

  # Check if the string is a number to be squared
  def CalcParser.is_square(string)
    return string.match?(/\d*\.?\d+\^/)
  end

  # Check if the string is an open or close curly bracket
  def CalcParser.is_bracket(string)
    return string.match?(/\(\)/)
  end

  # Extracts a number from a formula
  def CalcParser.extract_number(string)
    return string.scan(/\d*\.?\d+/)
  end

  def CalcParser.extract_operator(string)
    return string.scan(/[-+\/*%\^]|sqrt/)
  end

  # Checks if any valid operator is in the given array
  # TODO this needs renamed,
  def CalcParser.is_any_in_array(arr)
    for string in arr do
      return true if string.match?(/\d*\.?\d+\^|[-+\/*%()]|sqrt\(\d*\.?\d+\)/)
    end
    return false
  end

  # Checks the string for any operator
  def CalcParser.is_any(string)
    return true if string.match?(/\d*\.?\d+\^|[-+\/*%()]|sqrt\(\d*\.?\d+\)/)
    return false
  end

  # Checks if an operator is included in a list of given operators
  def CalcParser.includes_operator(*operators, v)
    return true if operators.include?("sqrt") && is_sqrt(v)
    return true if operators.include?("^") && is_square(v)
    return true if operators.include?(v)
    return false
  end

  # TODO validate the users input
  def CalcParser.validate_input(arr)
  end

end

# Default logger
$logger = Logger.new(STDOUT, datetime_format: '%H:%M:%S:%L')
$logger.level = Logger::INFO

operation = nil
$options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: calc.rb [options]"
  $options[:operation] = "No formula specified"
  opts.on("-o", "--operation=o", "Takes a mathematical formula and returns an answer, it can add, subtract, divide and multiply and conforms to PEDMA. Every non number character must be separated by a space") do |o|
    $options[:operation] = o
  end
  $options[:log_delay] = 0
  opts.on("-l", "--log-delay=l", "Any number value, this controls the flow output when verbose mode is activated") do |l|
    $options[:log_delay] = l.to_f
    puts l
  end
  $options[:verbose] = false
  opts.on("-v", "--verbose", "Output full log info") do
    $options[:verbose] = true
    # Set log level to debug for verbose
    $logger.level = Logger::DEBUG
  end
  opts.on("-h", "--help", "Display this screen") do
    puts opts
    exit
  end
end.parse!

if $options[:operation] == "No formula specified"
  $logger.info "No option has been specified and no calulation can take place, exiting"
  exit
end

# Used to apply a debug delay to the logger
def get_logger()
  sleep $options[:log_delay]
  return $logger
end
get_logger.debug("Starting in verbose mode")

get_logger.debug("Starting calculation")
get_logger.debug("Found formula '#{$options[:operation]}'")

get_logger.debug("Populating lookup tables")

# Valid exponents
$exponents = ["^", "sqrt"]
# This is a list of all valid characters, we do this so we can error check there
# users format
$valid_characters = ["(", ")", "+", "-", "*", "/", "^"]

add = -> (*n) { get_logger.debug("Adding #{n[0]} and #{n[1]}"); return n[0] + n[1]}
sub = -> (*n) { get_logger.debug("Subtracing #{n[0]} and #{n[1]}"); return n[0] - n[1]}
mul = -> (*n) { get_logger.debug("Multiplying #{n[0]} and #{n[1]}"); return n[0] * n[1]}
div = -> (*n) { get_logger.debug("Dividing #{n[0]} and #{n[1]}"); return n[0] / n[1]}
mod = -> (*n) { get_logger.debug("Mod of #{n[0]} and #{n[1]}"); return n[0] % n[1]}
square = -> (*n) { get_logger.debug("Squaring #{n[0]}"); return n[0] * n[0]}
sqrt = -> (*n) { get_logger.debug("Square root of #{n[0]}"); return Math.sqrt(n[0])}

# Lookup table
$operations = {"+" => add, "-" => sub, "*" => mul, "/" => div, "^" => square, "%" => mod, "sqrt" => sqrt}

get_logger.debug("Lookup tables populated")

# Returns the result of the given operator and number
def get_result(operator, *n)
  return $operations[operator].call(*n).to_s
end

def assign_operands(arr, i)
  left = (arr[i - 1])
  right = (arr[i + 1])
  get_logger.debug("Assigning #{left} to left operand and #{right} to right operand")
  return left, right
end

# Calculates invidual blocks of operator, such as 5 * 3 or 5 + 5
def calculate_blocks(s, start_i, end_i, *operators)
  # The reason you do this is because on the final pass, Rs won't me removed
  # before it does one last run, often Rs replace brackets and any number
  # multiplied by R is 0
  # If you don't remove the useless elements it all fucks up
  s.delete("R")
  get_logger.debug("Data is now #{s}")
  op_index = ""
  get_logger.debug("Calculating formula blocks with operators #{operators} in range #{start_i}..#{end_i} of #{s}")
  (start_i..end_i).each.with_index(start_i) { |i|
    v = s[i]
    get_logger.debug("Checking index #{i} in array, value present #{v}")
    # First check if operator is valid, this is done to conform to PEDMAS
    if CalcParser.includes_operator(*operators, v)
      op = CalcParser.extract_operator(v)[0]
      get_logger.debug("Found operator '#{op}'")
      if CalcParser.is_sqrt(v)
        number = CalcParser.extract_number(v)[0].to_f
        s[i] = get_result(op, number)
        break
      end
      if CalcParser.is_square(v)
        number = CalcParser.extract_number(v)[0].to_f
        s[i] = get_result(op, number)
        break
      end
      left_operand = s[i - 1]
      right_operand = s[i + 1]
      # Important check, makes sure that there are no double or missing operators. Needs tidied and debug messages added
      if CalcParser.is_operator(left_operand)
        exit
      elsif CalcParser.is_sqrt(left_operand)
        exit
      elsif CalcParser.is_bracket(left_operand)
      end
      if CalcParser.is_operator(right_operand)
        exit
      elsif CalcParser.is_sqrt(right_operand)
        exit
      elsif CalcParser.is_bracket(right_operand)
      end
      left_operand, right_operand = assign_operands(s, i)
      # Replaces the operator found with the answer found using the left and right operator
      s[i - 1] = "R"
      s[i + 1] = "R"
      result = get_result(op, left_operand.to_f, right_operand.to_f)
      get_logger.debug("Replace operator '#{v}' at index '#{op_index}' with result '#{result}'")
      s[i] = result
      break
    end
  }
end

def perform_pedmas(s, start_i, end_i)
  get_logger.debug("Now performing PEDMAS in range #{start_i}..#{end_i} of #{s}")
  #do exponents
  calculate_blocks(s, start_i, end_i, "^", "sqrt")
  # do all div/mul
  calculate_blocks(s, start_i, end_i, "*", "/", "%")
  # do all add/sub
  calculate_blocks(s, start_i, end_i, "+", "-")
  get_logger.debug("Removing elements tagged as 'R' #{s}")
  # Clean up
  s.delete("R")
  s.delete("B")
end

# Find all the brackets (open and closed) to conform to PEDMAS
def find_brackets(s, i)
  get_logger.debug("Removing elements tagged as 'B' #{s}")
  # If you don't remove the useless elements it all fucks up
  s.delete("B")
  get_logger.debug("Data is now #{s}")
  start_i = 0
  end_i = 0
  get_logger.debug("Finding brackets in formula '#{s}'' starting at index '#{i}', this is recursive so don't panic if it calls multiple times")
  # Find brackets in s
  (i..s.length - 1).each.with_index(i) { |y|
    break if y > s.length - 1
    if s[y] == "("
      get_logger.debug("Found open bracket at index '#{y}', tagging it as B")
      s[y] = "B"
      start_i = y
      # We call this recursively to get into the deepest nest of brackets
      get_logger.debug("Checking for nested brackets")
      find_brackets(s, start_i)
    end
    if s[y] == ")"
      get_logger.debug("Found close bracket at index '#{y}', tagging it as B")
      s[y] = "B"
      end_i = y
      has_opening_bracket = false
      perform_pedmas(s, i, end_i)
      break
    end
    get_logger.debug("Found value '#{s[y]}' at index '#{y}'")
  }
end

# better formatting
s = $options[:operation].scan(/\d*\.?\d+\^?|[-+\/*%()]|sqrt\(\d*\.?\d+\)/)
# s = convert_ints_to_floats(s)

# Do all brackets first
find_brackets(s, 0)
# do everything now outside brackets
# while contains_operator(s, 0, s.length, *$operators) do
get_logger().debug("Final pass starting...")
# Do final passes, we do this until we end up with one result
while CalcParser.is_any_in_array(s) do
  perform_pedmas(s, 0, s.length - 1)
end

# Output result
puts s.length == 1 ? "Result: #{s[0].scan(/\d*\.?\d+0?/)[0]}" : "Could not calculate answer, this is usually due to incorrect formatting. Sorry it's cryptic, working on it :)"
