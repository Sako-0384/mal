def READ(str)
  str
end

def EVAL(str)
  str
end

def PRINT(str)
  str
end

def rep(str)
  PRINT(EVAL(READ(str)))
end

while true
  print "user> "
  line = gets
  break if line.nil?
  puts rep(line)
end
