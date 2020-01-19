require_relative "types"
require_relative "reader"
require_relative "printer"

REPL_ENV = {
  '+': Proc.new { |l, r| MalInteger.new(l.val + r.val) },
  '-': Proc.new { |l, r| MalInteger.new(l.val - r.val) },
  '*': Proc.new { |l, r| MalInteger.new(l.val * r.val) },
  '/': Proc.new { |l, r| MalInteger.new(l.val / r.val) },
}

def eval_ast(ast, env)
  case ast
  when MalSymbol
    result = env[ast.val]
    throw "'#{ast.val}' not found" if result.nil?
    return result
  when MalList
    result = ast.val.map{ |el| EVAL(el, env) }
    return MalList.new(result)
  when MalVector
    result = ast.val.map{ |el| EVAL(el, env) }
    return MalVector.new(result)
  when MalHashMap
    result = ast.val.map{ |el| EVAL(el, env) }
    return MalHashMap.new(result)
  else
    return ast
  end
end

def READ(str)
  return read_str(str)
end

def EVAL(ast, env)
  case ast
  when MalList
    return ast if ast.val.empty?
    
    list = eval_ast(ast, env)

    func = list.val[0]
    args = list.val[1..-1]

    return func.call(*args)
  else
    return eval_ast(ast, env)
  end
end

def PRINT(ast)
  return pr_str(ast)
end

def rep(str)
  return PRINT(EVAL(READ(str), REPL_ENV))
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
