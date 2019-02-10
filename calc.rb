# More advanced version of the basic calculator, allows you to run it with args and pass in a single mathematical operation
# This works by passing in a mathem formula which is then interpreted and calculated
require 'optparse'

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
  end

  opts.on("-h", "--help", "Display this screen") do
    puts opts
  end
end.parse!

# Checks if the calculator is verbose and prints whater is passed in
def log_verbose(output)
  if $options[:verbose] == true
    t = Time.now.strftime("%H:%M:%S:%L -")
    # t = t.strftime("%H:%M:%S:%L")
    puts "#{t} #{output}"
  end
end

puts "Being verbose!" if $options[:verbose]

if $options[:operation] == "No formula specified"
  log_verbose("No option has been specified and no calulation can take place, exiting")
  exit
end

log_verbose("Starting calculation")
log_verbose("Found formula '#{$options[:operation]}', carrying out calculation")

log_verbose("Populating lookup tables")
add = -> (n1, n2) { log_verbose("Adding #{n1} and #{n2}"); return n1 + n2}
sub = -> (n1, n2) { log_verbose("Subtracing #{n1} and #{n2}"); return n1 - n2}
mul = -> (n1, n2) { log_verbose("Multiplying #{n1} and #{n2}"); return n1 * n2}
div = -> (n1, n2) { log_verbose("Dividing #{n1} and #{n2}"); return n1 / n2}
# Lookup table
$operations = {"+" => add, "-" => sub, "*" => mul, "/" => div}
log_verbose("Lookup tables populated")
# Need to remember these for string scanning
#$first_n = "[NOT SET]", $second_n = "[NOT SET]", $block_n = "", $op = "[NOT SET]"
# Assign to shorthand
s = $options[:operation].split(" ")

# Checks if a given string contains a valid number. Only floats are valid
def validate_number(string)
  log_verbose("Checking if string '#{string}' is a valid number: #{string.to_f.to_s == string}")
  return string.to_f.to_s == string
end

# Converts all the integers in the array to floats, this makes it easier to code, not really for anything else
def convert_ints_to_floats(s)
  log_verbose("Converting all integers in #{s} to floats")
  (0..s.length - 1).each do |i|
    c = s[i]
      if c.to_i.to_s == c
        s[i] = c.to_f.to_s
      end
  end
  log_verbose("Every integer in #{s} is now a float")
  return s
end

# Calculates all the multiplication and divisions first
def calculate_mul_div_blocks(s)
  first_n = ""
  second_n = ""
  op_index = ""
  log_verbose("Calculating formula blocks, the data is #{s}")
  s.each_with_index { |v, i|
    log_verbose("Checking index #{i} in array, value present #{v}")
    if v == "*"
      log_verbose("Found operator '#{v}'")
      op_index = i
      # Find number left of operand
      range = i-1..0
      (range.first).downto(range.last).each { |ln|
        log_verbose("Scanning left from index #{ln}, current character #{s[ln]}")
        if validate_number(s[ln])
          first_n += s[ln]
          s[ln] = "REMOVE"
        else
          log_verbose("Left operand: #{first_n}")
          break
        end
      }
      # First right operand
      (i + 1..s.length - 1).each do |rn|
        log_verbose("Scanning right from index #{rn}, current character #{s[rn]}")
        if validate_number(s[rn])
          second_n += s[rn]
          s[rn] = "REMOVE"
        else
          log_verbose("Right operand: #{second_n}")
          # Calculate using the left and right operand with the found operator and replace it in the array
          op = s[op_index]
          result = $operations[op].call(first_n.to_f, second_n.to_f).to_s
          s[op_index] = result
          log_verbose("Removing empty elements")
          s.delete("REMOVE")
          break
        end
      end
    end
  }
end

# Important, everything needs to be floats
s = convert_ints_to_floats(s)

while s.include?("*") or s.include?("/") do
  calculate_mul_div_blocks(s)
end

puts "The calculation is now complete, the result was\n'#{s}'"

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
