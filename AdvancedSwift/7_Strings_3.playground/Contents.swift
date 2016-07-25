//: Playground - noun: a place where people can play

import UIKit

//: # String Performance


protocol StringViewSelector {
  associatedtype ViewType: CollectionType
  
  static var caret: ViewType.Generator.Element { get }
  static var asterisk: ViewType.Generator.Element { get }
  static var period: ViewType.Generator.Element { get }
  static var dollar: ViewType.Generator.Element { get }
  
  static func viewFrom(s: String) -> ViewType
}


struct UTF8ViewSelector: StringViewSelector {
  static var caret: UInt8 { return UInt8(ascii: "^") }
  static var asterisk: UInt8 { return UInt8(ascii: "*") }
  static var period: UInt8 { return UInt8(ascii: ".") }
  static var dollar: UInt8 { return UInt8(ascii: "$") }
  
  static func viewFrom(s: String) -> String.UTF8View {
    return s.utf8
  }
}

struct CharacterViewSelector: StringViewSelector {
  static var caret: Character { return "^" }
  static var asterisk: Character { return "*" }
  static var period: Character { return "." }
  static var dollar: Character { return "$" }
  
  static func viewFrom(s: String) -> String.CharacterView {
    return s.characters
  }
}




sizeof(CharacterViewSelector)

struct Regex<V: StringViewSelector where V.ViewType.Generator.Element: Equatable, V.ViewType.SubSequence == V.ViewType> {
  let regexp: String
  
  init(_ regexp: String) {
    self.regexp = regexp
  }
  
  func match(text: String) -> Bool {
    let text = V.viewFrom(text)
    let regexp = V.viewFrom(self.regexp)
    if regexp.first == V.caret {
      return Regex.matchHere(regexp.dropFirst(), text)
    }
    
    var idx = text.startIndex
    while true {
      if Regex.matchHere(regexp, text.suffixFrom(idx)) {
        return true
      }
      guard idx != text.endIndex else { break }
      idx = idx.successor()
    }
    return false
  }
  
  static func matchHere(regexp: V.ViewType, _ text: V.ViewType) -> Bool {
    return true
  }
  
}


func benchmark<V: StringViewSelector where V.ViewType.Generator.Element: Equatable, V.ViewType.SubSequence == V.ViewType>(_: V.Type) {
  let r = Regex<V>("h..a*")
  var count = 0
  
  let startTime = CFAbsoluteTimeGetCurrent()
  while let line = readLine() {
    if r.match(line) {
      count = count &+ 1
    }
  }
  
  let totalTime = CFAbsoluteTimeGetCurrent() - startTime
  print("\(V.self):\(totalTime)")
}

func ~=<T: Equatable>(lhs: T, rhs: T?) -> Bool {
  return lhs == rhs
}

//switch Process.arguments.last {
//  case "ch": benchmark(CharacterViewSelector.self)
//  case "8": benchmark(UTF8ViewSelector.self)
//  default: print("unrecognized view type")
//}