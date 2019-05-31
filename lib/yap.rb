require "yap/version"
require "parser/current"

module Yap
  module_function

  def ast(code)
    Parser::CurrentRuby.parse(code)
  end

  def parse(string)
    Parse.new(string).parse
  end

  def match(expression, ast)
    head, *tail =  expression
    return false unless match_child(head, ast)
    tail.each_with_index do |match_element, i|
      ast_element = ast.children[i]
      return false unless match(match_element, ast_element)
    end
    true
  end

  def match_child(expression, ast_element)
    compare_ast = ast_element.respond_to?(:type) ? ast_element.type : ast_element
    compare_exp = expression.is_a?(Array) ? expression.first : expression
    puts "#{compare_exp} == #{compare_ast}"
    case compare_exp
    when Any
      compare_exp.tokens.any? {|token| match(token, ast_element)}
    else
      compare_ast == compare_exp
    end
  end

  class Any < Struct.new(:tokens)
  end

  class Parse
    def initialize string
      @tokens = string.scan /\+|\(|\)|\d+|\w+|\{|\}/
    end

    def parse
      case token=@tokens.shift
      when '(' then parse_until(')')
      when '{' then Any.new(parse_until('}'))
      when /\d+/ then token.to_i
      else token.to_sym
      end
    end

    def parse_until(token)
      box = []
      box << parse until @tokens.first == token
      @tokens.shift
      box
    end
  end
end
