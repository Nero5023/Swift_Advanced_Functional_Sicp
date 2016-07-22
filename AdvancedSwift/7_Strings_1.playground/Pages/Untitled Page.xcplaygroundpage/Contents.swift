//: Playground - noun: a place where people can play

import UIKit


"\u{20AC}"

//: # Grapheme Clusters and Canonical Equivalence

let single = "Pok\u{00E9}mon"
let double = "Pok\u{0065}\u{0301}mon"

single.characters.count == double.characters.count

single.utf8.count
double.utf8.count

single.utf16.count
double.utf16.count

single.utf16.elementsEqual(double.utf16)

let chars: [Character] = [
  "\u{1ECD}\u{300}",
  "\u{F2}\u{323}",
  "\u{6F}\u{323}\u{300}",
  "\u{6F}\u{300}\u{323}",
]

extension CollectionType {
  func all(fileter: Self.Generator.Element -> Bool) -> Bool {
    for element in self {
      if !fileter(element) { return false }
    }
    return true
  }
}

assert(chars.dropFirst().all{
  $0 == chars.first
  }, "All element in chars should be equal")

//chars.dropFirst().all {
//  $0 == chars.first
//}


let zalgo = "s̼̐͗͜o̠̦̤ͯͥ̒ͫ́ͅo̺̪͖̗̽ͩ̃͟ͅn̢͔͖͇͇͉̫̰ͪ͑"


let flags = "🇳🇱🇬🇧"
flags.characters.count
print(flags.unicodeScalars.map{String($0)}.joinWithSeparator(","))

//: # Strings and Collections
extension String: CollectionType { }

extension String: RangeReplaceableCollectionType { }

var greeting = "Hello, world!"
if let comma = greeting.indexOf(",") {
  print(greeting[greeting.startIndex..<comma])
  greeting.replaceRange(greeting.indices, with: "How about some original example strings?")
}

let str = "abcdef"
let idx = str.startIndex.advancedBy(5)
str[idx]

let safeIdx = str.startIndex.advancedBy(400, limit: str.endIndex)
assert(safeIdx == str.endIndex)

extension String {
  subscript(idx: Int) -> Character {
    let strIdx = self.startIndex.advancedBy(idx, limit: endIndex)
    guard strIdx != endIndex else { fatalError("String index out of bounds") }
    return self[strIdx]
  }
}

//: # Strings and slicing

let world = "Hello, world!".characters.suffix(6).dropLast()
print(world)


let commaSeparatedArray = "a,b,c".characters.split{ $0 == "," }

extension String {
  func wrap(after: Int = 70) -> String {
    var i = 0
    let lines = self.characters.split(allowEmptySlices: true) { character in
      switch character {
      case "\n"," " where i >= after:
        i = 0
        return true
      default:
        i += 1
        return false
      }
    }.map(String.init)
    return lines.joinWithSeparator("\n")
  }
}

extension CollectionType where Generator.Element: Equatable {
  func split<S: SequenceType where Generator.Element == S.Generator.Element>(separators: S) -> [SubSequence] {
    return split { separators.contains($0) }
  }
}

"Hello, world! kill".characters.split(",!".characters).map(String.init)


//: # A simple regular expression matcher

public struct Regex {
  private let regexp: String
  
  public init(_ regexp: String) {
    self.regexp = regexp
  }
}

extension Regex {
  public func match(text: String) -> Bool {
    if regexp.characters.first == "^" {
      return Regex.matchHere(regexp.characters.dropFirst(), text.characters)
    }
    
    var idx = text.startIndex
    while true {
      if Regex.matchHere(regexp.characters, text.characters.suffixFrom(idx)) {
        return true
      }
      guard idx != text.endIndex else { break }
      idx = idx.successor()
    }
    
    return false
  }
  
  
  private static func matchHere(regexp: String.CharacterView, _ text: String.CharacterView) -> Bool {
    if regexp.isEmpty {
      return true
    }
    
    if let c = regexp.first where regexp.dropFirst().first == "*" {
      return matchStar(c, regexp.dropFirst(2), text)
    }
    
    if regexp.first == "$" && regexp.dropFirst().isEmpty {
      return text.isEmpty
    }
    
    if let tc = text.first, rc = regexp.first where rc == "." || tc == rc {
      return matchHere(regexp.dropFirst(), text.dropFirst())
    }
    
    return false
  }
  
  
  private static func matchStar(c: Character, _ regexp: String.CharacterView, _ text: String.CharacterView) -> Bool {
    var idx = text.startIndex
    while true {
      if matchHere(regexp, text.suffixFrom(idx)) {
        return true
      }
      if idx == text.endIndex || (text[idx] != c && c != ".") {
        return false
      }
      idx = idx.successor()
    }
  }
}

Regex("^h..lo*!$").match("hellooooo!")


//: # StringLiteralConvertible

extension Regex: StringLiteralConvertible {
  
  public init(stringLiteral value: Self.StringLiteralType) {
    regexp = value
  }
  
  public init(extendedGraphemeClusterLiteral value: String) {
    self = Regex(stringLiteral: value)
  }
  
  public init(unicodeScalarLiteral value: String) {
    self = Regex(stringLiteral: value)
  }

}

let r: Regex = "^h..lo*!$"

