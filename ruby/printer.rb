require_relative "types"

def pr_str(el)
  return case el
  when MalSymbol
    el.val
  when MalKeyword
    el.val
  when MalInteger
    el.val
  when MalString
    el.val
  when MalNil
    'nil'
  when MalTrue
    'true'
  when MalFalse
    'false'
  when MalList
    list = el.val
    "(#{list.map{ | el | pr_str(el) }.join(' ')})"
  when MalVector
    list = el.val
    "[#{list.map{ | el | pr_str(el) }.join(' ')}]"
  when MalHashMap
    list = el.val
    "{#{list.map{ | el | pr_str(el) }.join(' ')}}"
  end
end
