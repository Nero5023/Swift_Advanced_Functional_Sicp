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
