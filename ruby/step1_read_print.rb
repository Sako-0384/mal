require_relative "reader"
require_relative "printer"

def READ(str)
  return read_str(str)
end

def EVAL(str)
  return str
end

def PRINT(str)
  return pr_str(str)
end

def rep(str)
  return PRINT(EVAL(READ(str)))
end

while true
  print "user> "
  line = gets
  break if line.nil?
  begin
    puts rep(line)
  rescue Exception => e
    puts "Error: #{e}"
    puts e.backtrace.join("\n")
  end
end
