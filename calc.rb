# More advanced version of the basic calculator, allows you to run it with args and pass in a single mathematical operation
require 'optparse'

operation = nil
$options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: calc.rb [options]"

  $options[:operation] = "No operation specified"
  opts.on("-o", "--operation=o", "Takes a mathematical question and returns an answer, it can add, subtract, divide and multiply") do |o|
    $options[:operation] = o
  end

  $options[:verbose] = false
  opts.on("-v", "--verbose", "Output full log info") do
    $options[:verbose] = true
  end

  opts.on("-h", "--help", "Dispaly this screen") do
    puts opts
  end
end.parse!

# Checks if the calculator is verbose and prints whater is passed in
def be_verbose(output)
  if $options[:verbose] == true
    t = Time.now.strftime("%H:%M:%S:%L -")
    # t = t.strftime("%H:%M:%S:%L")
    puts "#{t} #{output}"
  end
end

puts "Being verbose!" if $options[:verbose]

if $options[:operation] == "No operation specified"
  be_verbose("No options has been specified and no calulation can take place, exiting")
  exit
end

be_verbose("Starting calculation")
be_verbose("Found operation '#{$options[:operation]}', carrying out calculation")

be_verbose("Populating lookup table")
add = -> (n1, n2) { be_verbose("Adding #{n1} and #{n2}"); return n1 + n2}
sub = -> (n1, n2) { be_verbose("Subtracing #{n1} and #{n2}"); return n1 - n2}
mul = -> (n1, n2) { be_verbose("Multiplying #{n1} and #{n2}"); return n1 * n2}
div = -> (n1, n2) { be_verbose("Dividing #{n1} and #{n2}"); return n1 / n2}
# Lookup table
operations = {"+" => add, "-" => sub, "*" => mul, "/" => div}
be_verbose("Lookup tables populated")
# Need to remember these for string scanning
$first_n = "[NOT SET]", $second_n = "[NOT SET]", $block_n = "", $op = "[NOT SET]"
# Assign to shorthand
s = $options[:operation]
be_verbose("Removing whitespace from operation #{s}")
# Remove whitespace
s = s.tr(" ", "")
be_verbose("Whitespace removed, new format : #{s}")

def is_first_n_set
  return !($first_n.eql? "[NOT SET]")
end

def is_second_n_set
  return !($second_n.eql? "[NOT SET]")
end

def is_op_set
  return !($op.eql? "[NOT SET]")
end

# Multiplication and division first
m_d_exists = true

# Assume there are multiplication/division to be carried out
while m_d_exists
  be_verbose("Running recursive search for multiplication and division, left to right")
  m_d_exists = false
  $first_n = "[NOT SET]"
  $second_n = "[NOT SET]"

  n_builder = ""
  s.each_char { |c|
    sleep(0.75)
    be_verbose("Iterating string, current character - '#{c}'")
    $block_n += c
    if !(is_first_n_set) and c == "*" or c == "/"
      be_verbose("Found operator '#{c}'")
      m_d_exists = true
      $op = c
      be_verbose("Operator set to '#{$op}'")
      $first_n = n_builder.tr($op, "")
      be_verbose("First number set to '#{$first_n}'")
      be_verbose("New block number is '#{$block_n}'")
      n_builder = ""
    else
    # Add character to number
      n_builder += c
    end
  }
  be_verbose("Reached end of string")
  if is_op_set and is_first_n_set
    be_verbose("Setting second number to '#{n_builder}'")
    $second_n = n_builder.tr($op, "")
    be_verbose("New block number is '#{$block_n}'")
    to_be_subbed = operations[$op].call($first_n.to_f, $second_n.to_f).to_s
    be_verbose("After using the '#{$op}' the block is now '#{to_be_subbed}' and will now replace the existing block '#{$block_n}'")
    s = s.sub($block_n, to_be_subbed)
    be_verbose("The block has now merged with the main operation, it is now '#{s}'")
  end
end

puts "The calculation is now complete, the result was \n '#{s}'"

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
