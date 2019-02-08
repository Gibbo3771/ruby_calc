# More advanced version of the basic calculator, allows you to run it with args and pass in a single mathematical operation
require 'optparse'

operation = nil
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: calc.rb [options]"

  options[:operation] = "No operation specified"
  opts.on("-o", "--operation=o", "Takes a mathematical question and returns an answer, it can add, subtract, divide and multiply") do |o|
    options[:operation] = o
  end

  options[:verbose] = false
  opts.on("-v", "--verbose", "Output full log info") do
    options[:verbose] = true
  end

  opts.on("-h", "--help", "Dispaly this screen") do
    puts opts
  end
end.parse!

# Checks if the calculator is verbose and prints whater is passed in
def be_verbose(options, output)
  if options[:verbose] == true
    t = Time.now.strftime("%H:%M:%S:%L -")
    # t = t.strftime("%H:%M:%S:%L")
    puts "#{t} #{output}"
  end
end

puts "Being verbose!" if options[:verbose]

if options[:operation] == "No operation specified"
  be_verbose(options, "No options has been specified and no calulation can take place, exiting")
  exit
end

be_verbose(options, "Starting calculation")
be_verbose(options, "Found operation '#{options[:operation]}', carrying out calculation")

be_verbose(options, "Populating lookup table")
add = -> (n1, n2) { be_verbose(options, "Adding #{n1} and #{n2}"); return n1 + n2}
sub = -> (n1, n2) { be_verbose(options, "Subtracing #{n1} and #{n2}"); return n1 - n2}
mul = -> (n1, n2) { be_verbose(options, "Multiplying #{n1} and #{n2}"); return n1 * n2}
div = -> (n1, n2) { be_verbose(options, "Dividing #{n1} and #{n2}"); return n1 / n2}
# Lookup table
operations = {"+" => add, "-" => sub, "*" => mul, "/" => div}
be_verbose(options, "Lookup tables populated")
# Need to remember these for string scanning
cur_n = nil, prev_n = nil
# Assign to shorthand
s = options[:operation]
be_verbose(options, "Removing whitespace from operation #{s}")
# Remove whitespace
s = s.tr(" ", "")
be_verbose(options, "Whitespace removed, new format : #{s}")

# Multiplication and division first
m_d_exists = true

while m_d_exists
  str_builder = s[0]
  s.each_char { |c|
    if b_t
      str_builder += c
    end
  }
  puts str_builder
end
