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
  opts.on("-o", "--operation=o", "Takes a mathematical formula and returns an answer, it can add, subtract, divide and multiply.") do |o|
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
# Need to remember these for string scanning
#$first_n = "[NOT SET]", $second_n = "[NOT SET]", $block_n = "", $op = "[NOT SET]"
# Assign to shorthand
s = $options[:operation].split(" ")

# Checks if a given string contains a valid number. Only floats are valid
def validate_number(string)
  $logger.debug("Checking if string '#{string}' is a valid number: #{string.to_f.to_s == string}")
  return string.to_f.to_s == string
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
  $logger.debug("Assigning #{arr[i - 1]} to left operand and #{arr[ i + 1]} to right operand")
  return arr[i - 1], arr[i + 1]
end

# Calculates invidual blocks of operator, such as 5 * 3 or 5 + 5
def calculate_blocks(s, *operators)
  op_index = ""
  $logger.debug("Calculating formula blocks, the data is #{s}")
  s.each_with_index { |v, i|
    $logger.debug("Checking index #{i} in array, value present #{v}")
    if operators.include?(v)
      $logger.debug("Found operator '#{v}'")
      op_index = i
      # Important check, makes sure that there are no double operators or missing numbers
      if i == 0 or (i + 1) > (s.length - 1)
        $logger.debug("No #{i == 0 ? "left" : "right"} operand for operator '#{v}', found at index '#{i}'")
        exit
      end
      left_operand, right_operand = assign_operands(s, i)
      # Replaces the operator found with the answer found using the left and right operator
      s[op_index] = $operations[s[op_index]].call(left_operand.to_f, right_operand.to_f).to_s
      s[i - 1] = "R"
      s[i + 1] = "R"
      $logger.debug("Removing elements at index #{i - 1} and #{i + 1}")
      s.delete("R")
      break
    end
  }
end

# Important, everything needs to be floats
s = convert_ints_to_floats(s)

# do all div/mul
while s.include?("*") or s.include?("/") do
  calculate_blocks(s, "*", "/")
end

# do all add/sub
while s.include?("+") or s.include?("-") do
  calculate_blocks(s, "+", "-")
end

 puts "Result: #{s[0]}"

# if first_n != "[NOT SET]"
#   be_verbose(options, "Found end of second number")
#   second_n = n_builder.tr(op, "")
#   be_verbose(options, "Second number set to '#{second_n}'")
#   s.sub(block_n, operations[op].call(first_n.to_d, second_n.to_d))
#   be_verbose(options, "New block number is '#{block_n}' and is complete, it will now be subbed into the main operation")
#   block_n = ""
#   first_n = "[NOT SET]"
#   second_n = "[NOT SET]"
#   break
# end
