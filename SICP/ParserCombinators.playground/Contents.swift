//: Playground - noun: a place where people can play

import Foundation

struct Parser<Tokens, A> {
  let parse: (Tokens) -> (A, Tokens)?
}
typealias Stream<A> = Parser<String.CharacterView, A>
typealias Expression = Stream<Int>

func character(satisfy condition: @escaping (Character) -> Bool ) -> Stream<Character> {
  return Stream<Character> { input in
    guard let character = input.first, condition(character) else { return nil }
    return (character, input.dropFirst())
  }
}

extension Character {
  public var unicodeScalar: UnicodeScalar {
    return String(self).unicodeScalars.first!
  }
}

extension CharacterSet {
  var element: Stream<Character> {
    return character {
      self.contains($0.unicodeScalar)
    }
  }
  
  static var digit: Stream<Character> {
    return CharacterSet.decimalDigits.element
  }
}

let digit = CharacterSet.digit
digit.parse("123".characters)

func run<A>(_ parser: Stream<A>, _ string: String) -> (A, String)? {
  guard  let (result, remainder) = parser.parse(string.characters) else {
    return nil
  }
  return (result, String(remainder))
}

run(digit, "123")

let multiSign = character { $0 == "*" }
let plusSign = character { $0 == "+" }


func token(_ one: Character) -> Stream<Character> {
  return character { $0 == one }
}

extension Parser {
  var many: Parser<Tokens, [A]> {
    return Parser<Tokens, [A]> { stream in
      var result: [A] = []
      var remainder = stream
      while let (element, newRemainder) = self.parse(remainder) {
        result.append(element)
        remainder = newRemainder
      }
      return (result, remainder)
    }
  }
}


extension Parser {
  func map<B>(_ transform: @escaping (A) -> B) -> Parser<Tokens, B> {
    return Parser<Tokens, B> { stream in
      guard let (result, remainder) = self.parse(stream) else { return nil }
      return (transform(result), remainder)
    }
  }
}

let int = digit.many.map { x in
  Int(String(x))!
}

run(int, "123")

// 连接上
extension Parser {
  func followed<B>(by other: Parser<Tokens, B>) -> Parser<Tokens, (A,B)> {
    return Parser<Tokens, (A,B)> { input in
      guard let (result1, remainder1) = self.parse(input) else { return nil }
      guard let (result2, remainder2) = other.parse(remainder1) else { return nil }
      return ((result1, result2), remainder2)
    }
  }
}

//这里map前面的 parse 返回值是 ((Int, Character), Int)
int.followed(by: token("*")).followed(by: int)
let mutiplication = int.followed(by: token("*")).followed(by: int).map { lhs, rhs in
  return lhs.0 * rhs
}

run(mutiplication, "3*60")

func multiply(_ x: Int, _ op: Character, _ y: Int) -> Int {
  return x*y
}

public func curry<A, B, C, Result>(_ f: @escaping (A, B, C) -> Result) -> (A) -> (B) -> (C) -> (Result) {
  return { a in { b in { c in f(a,b,c) }}}
}

curry(multiply)(3)("*")(60)

let mutiplication2 = int.map(curry(multiply)).followed(by: token("*")).map{ f, x in f(x) }.followed(by: int).map { f, x in f(x) }
run(mutiplication2, "3*60")





precedencegroup OpPrecedence {
  associativity: left
  higherThan: AdditionPrecedence
}

infix operator <*>: OpPrecedence

func  <*><A, B, Tokens>(lhs: Parser<Tokens, (A) -> B>, rhs: Parser<Tokens, A>) -> Parser<Tokens, B>  {
  return lhs.followed(by: rhs).map{ f, x in f(x) }
}

let mutiplication3 = int.map(curry(multiply)) <*> token("*") <*> int
run(mutiplication3, "3*60") // (.0 180, .1 "")

// map operation
infix operator <^>: OpPrecedence
func <^><A, B, Tokens>(lhs: @escaping (A) -> B, rhs: Parser<Tokens, A>) -> Parser<Tokens, B> {
  return rhs.map(lhs)
}
let mutiplication4 = curry(multiply) <^> int <*> token("*") <*> int


// 忽视左边的结果
infix operator <*: OpPrecedence
func <*<A, B, Tokens>(lhs: Parser<Tokens, A>, rhs: Parser<Tokens, B>) -> Parser<Tokens, A> {
  return lhs.followed(by: rhs).map { x, _ in x }
}


public func curry<A, B , Result>(_ f: @escaping (A, B) -> Result) -> (A) -> (B) -> (Result) {
  return { a in { b in f(a,b) }}
}


let mutiplication5 = curry(*) <^> int <* token("*") <*> int
run(mutiplication5, "6*7") // (.0 42, .1 "")
let addition = curry(+) <^> int <* token("+") <*> int
run(addition, "2+40") // (.0 42, .1 "")

// 返回解析对的值
extension Parser {
  func or(_ other: Parser<Tokens, A>) -> Parser<Tokens, A> {
    return Parser { input in
      guard let result = self.parse(input) else {
        return other.parse(input)
      }
      return result
    }
  }
}


run(token("a").or(token("b")), "bcd") // (.0 "b", .1 "cd")
func |<A, Tokens>(lhs: Parser<Tokens, A>, rhs: Parser<Tokens, A>) -> Parser<Tokens, A> {
  return lhs.or(rhs)
}
run(token("a") | token("b"), "bcd") // (.0 "b", .1 "cd")

// 乘法优先级高
// mutiplication5 在前面  优先 mutiplication5
let multiply: Expression = mutiplication5 | int
let add: Expression = curry(+) <^> multiply <* token("+") <*> multiply
let expression: Expression = add | multiply
run(expression, "6*7") // (.0 42, .1 "")
run(expression, "2+40") // (.0 42, .1 "")
run(expression, "2+4*10") // (.0 42, .1 "")
run(expression, "4*10+2") // (.0 42, .1 "")


