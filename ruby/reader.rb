require_relative "types"

class Reader
  def initialize(tokens)
    @tokens = tokens
    @position = 0
  end

  def next
    token = @tokens[@position]
    @position += 1
    token
  end

  def peek
    @tokens[@position]
  end
end

def read_str(str)
  tokens = tokenize(str)
  return if tokens.empty?
  reader = Reader.new(tokens)
  read_form(reader)
end

def tokenize(str)
  tokens = str.scan(/[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"?|;.*|[^\s\[\]{}('"`,;)]*)/)
    .map{ | matches | matches.first }
    .select{ | token | !token.match(/^;|^$/) }
  return tokens
end

def read_form(reader)
  token = reader.peek
  case token
  when '\''
    reader.next
    return MalList.new([MalSymbol.new('quote'), read_form(reader)])
  when '`'
    reader.next
    return MalList.new([MalSymbol.new('quasiquote'), read_form(reader)])
  when '~'
    reader.next
    return MalList.new([MalSymbol.new('unquote'), read_form(reader)])
  when '~@'
    reader.next
    return MalList.new([MalSymbol.new('splice-unquote'), read_form(reader)])
  when '@'
    reader.next
    return MalList.new([MalSymbol.new('deref'), read_form(reader)])
  when '^'
    reader.next
    map = read_form(reader)
    obj = read_form(reader)
    return MalList.new([MalSymbol.new('with-meta'), obj, map])
  when '('
    return read_list(reader, MalList, '(', ')')
  when ')'
    throw "unexpected #{token}"
  when '['
    return read_list(reader, MalVector, '[', ']')
  when ']'
    throw "unexpected #{token}"
  when '{'
    return read_list(reader, MalHashMap, '{', '}')
  when '}'
    throw "unexpected #{token}"
  else
    return read_atom(reader)
  end
end

def read_list(reader, type, left = '(', right = ')')
  l = reader.next

  throw "expected '#{left}', got '#{l}'" if l != left

  result = []
  while true
    token = reader.peek
    
    throw "expected '#{right}', got EOF" if token.nil?

    if token == right
      reader.next
      break
    end
    result.push read_form(reader)
  end

  return type.new(result)
end

def read_atom(reader)
  token = reader.next

  case token
  when /^-?[0-9]+$/
    return MalInteger.new(token)
  when /^"(?:\\.|[^\\"])*"$/
    return MalString.new(token)
  when /^"/
    throw 'expected \'"\', got EOF'
  when /^nil$/
    return MalNil.new
  when /^true$/
    return MalTrue.new
  when /^false$/
    return MalFalse.new
  else
    return MalSymbol.new(token)
  end
end
