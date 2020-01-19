class MalType
end

class MalList < MalType
  attr_reader :val
  def initialize(val)
    @val = val
  end
end

class MalVector < MalType
  attr_reader :val
  def initialize(val)
    @val = val
  end
end

class MalHashMap < MalType
  attr_reader :val
  def initialize(val)
    @val = val
  end
end

class MalInteger < MalType
  attr_reader :val
  def initialize(val)
    @val = val
  end
end

class MalString < MalType
  attr_reader :val
  def initialize(val)
    @val = val
  end
end

class MalNil < MalType
  def initialize
  end
end

class MalTrue < MalType
  def initialize
  end
end

class MalFalse < MalType
  def initialize
  end
end

class MalSymbol < MalType
  attr_reader :val
  def initialize(symbol)
    @val = symbol
  end
end

class MalKeyword < MalType
  attr_reader :val
  def initialize(keyword)
    @val = keyword 
  end
end
