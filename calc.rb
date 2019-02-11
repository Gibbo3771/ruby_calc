#!/bin/ruby
# More advanced version of the basic calculator, allows you to run it with args and pass in a single mathematical operation
require 'optparse'
require 'logger'

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

$logger.debug("Starting in verbose mode")

$logger.debug("Starting calculation")
$logger.debug("Found formula '#{$options[:operation]}', carrying out calculation")

$logger.debug("Populating lookup tables")
add = -> (n1, n2) { $logger.debug("Adding #{n1} and #{n2}"); return n1 + n2}
sub = -> (n1, n2) { $logger.debug("Subtracing #{n1} and #{n2}"); return n1 - n2}
mul = -> (n1, n2) { $logger.debug("Multiplying #{n1} and #{n2}"); return n1 * n2}
div = -> (n1, n2) { $logger.debug("Dividing #{n1} and #{n2}"); return n1 / n2}
# Lookup table
$operations = {"+" => add, "-" => sub, "*" => mul, "/" => div}
$logger.debug("Lookup tables populated")
# Assign to shorthand
s = $options[:operation].split(" ")

# Checks if a given string contains a valid number. Only floats are valid
def validate_number(string)
  $logger.debug("Checking if string '#{string}' is a valid number: #{string.to_f.to_s == string}")
  return string.to_f.to_s == string
end

def contains_operator(s, *operators)
  (0..s.length - 1).each do |i|
    if operators.include?(s[i])
      $logger.debug("Operator #{s[i]} is in the valid list if operators (#{operators})")
      return true
    end
  end
  return false
end

# Converts all the integers in the array to floats, this makes it easier to code, not really for anything else
def convert_ints_to_floats(s)
  $logger.debug("Converting all integers in #{s} to floats")
  (0..s.length - 1).each do |i|
    c = s[i]
      if c.to_i.to_s == c
        s[i] = c.to_f.to_s
      end
  end
  $logger.debug("Every integer in #{s} is now a float")
  return s
end

def assign_operands(arr, i)
  left = validate_number(arr[i - 1]) ? arr[i - 1] : false
  right = validate_number(arr[i + 1]) ? arr[i + 1] : false
  if !left or !right
    $logger.info("Attempt to assign #{left ? "left" : "right"} operand failed, '#{!left ? arr[i - 1] : arr[i + 1]}' is not a number. Check your spacing")
    exit
  end
  $logger.debug("Assigning #{arr[i - 1]} to left operand and #{arr[ i + 1]} to right operand")
  return arr[i - 1], arr[i + 1]
end

# Calculates invidual blocks of operator, such as 5 * 3 or 5 + 5
def calculate_blocks(s, *operators)
  # Always delete all removable elements before attempting to carry out calculations
  s.delete("R")
  op_index = ""
  $logger.debug("Calculating formula blocks, the data is #{s}")
  s.each_with_index { |v, i|
    $logger.debug("Checking index #{i} in array, value present #{v}")
    if operators.include?(v)
      $logger.debug("Found operator '#{v}'")
      op_index = i
      # Important check, makes sure that there are no double operators or missing numbers
      if i == 0 or (i + 1) > (s.length - 1)
        $logger.info("No #{i == 0 ? "left" : "right"} operand for operator '#{v}', found at index '#{i}'")
        exit
      end
      left_operand, right_operand = assign_operands(s, i)
      # Replaces the operator found with the answer found using the left and right operator
      s[op_index] = $operations[s[op_index]].call(left_operand.to_f, right_operand.to_f).to_s
      s[i - 1] = "R"
      s[i + 1] = "R"
      s.delete("R")
      $logger.debug("Removing elements at index #{i - 1} and #{i + 1}")
      break
    end
  }
  # Recursion baby. Continue to run this until all valid operators have been
  # performed on
  if(contains_operator(s, *operators))
    calculate_blocks(s, *operators)
  end
end

# Find all the brackets (open and closed) to conform to PEDMAS
def find_brackets(s, i)
  nested_s = []
  n_nests = 0
  left_bracket_i = 0
  right_bracket_i = 0
  $logger.debug("Finding brackets in formula '#{s}'' starting at index '#{i}', this is recursive so don't panic if it calls multiple times")
  # Find brackets in s
  (i..s.length - 1).each.with_index(i) { |y|
    if s[y] == "("
      $logger.debug("Found open bracket at index '#{y}', flagging it for removal")
      s[y] = "R"
      # We call this recursively to get into the deepest nest of brackets
      find_brackets(s, y + 1)
    end
    if s[y] == ")"
      $logger.debug("Found close bracket at index '#{y}', flagging it for removal")
      s[y] = "R"
      break
    end
    nested_s.push("#{s[y]}")
  }
  #find_brackets(nested_s, left_bracket_i + 1)
  $logger.debug("Found this formula nested in brackets #{nested_s}")
  # do all div/mul
  calculate_blocks(nested_s, "*", "/")
  # do all add/sub
  calculate_blocks(nested_s, "+", "-")
end

# Important, everything needs to be floats
s = convert_ints_to_floats(s)

# Do all brackets first
find_brackets(s, 0)

# do all div/mul
calculate_blocks(s, "*", "/")

# do all add/sub
calculate_blocks(s, "+", "-")

# Output result
puts "Result: #{s[0]}"
