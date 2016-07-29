//: Playground - noun: a place where people can play

import UIKit

//: # Library Code

let old = [1,2,3]
let new = [1,2,4,5]

Set(new).subtract(old)

let oldSet = Set(old)
new.filter{ !oldSet.contains($0) }


extension CollectionType where Generator.Element: Hashable {
  func substract(toRemove: [Generator.Element]) -> [Generator.Element] {
    let removeSet = Set(toRemove)
    return self.filter {
      !removeSet.contains($0)
    }
  }
}

new.substract(old)

extension SequenceType where Generator.Element: Equatable {
  func subtract(toRemove: [Generator.Element]) -> [Generator.Element] {
    return self.filter {
      !toRemove.contains($0)
    }
  }
}

let ranges1 = [0..<1, 1..<4]
let ranges2 = [0..<1, 1..<4, 5..<10]
print(ranges2.subtract(ranges1))

extension SequenceType where Generator.Element: Hashable {
  func subtract<S: SequenceType where S.Generator.Element == Generator.Element>(toRemove: S) -> [Generator.Element] {
    let removeSet = Set(toRemove)
    return self.filter{ !removeSet.contains($0) }
  }
}

[2,4,8].subtract(0..<3)

// Parameterizing Behavior with Closures

extension SequenceType {
  func subtract<S: SequenceType>(toRemove: S, predicate: (Generator.Element, S.Generator.Element)->Bool) -> [Generator.Element] {
    return self.filter { sourceElement in
      !toRemove.contains { removeElement in
        predicate(sourceElement, removeElement)
      }
    }
  }
}

[[1,2], [3], [4]].subtract([[1,2],[3]]) { $0 == $1 } as [[Int]]

let ints = [1,2,3]
let strings = ["1", "2"]
ints.subtract(strings) { $0 == Int($1) }

//: # Operating Generically on Collections

extension Array {
  func binarySearch(value: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int? {
    var left = 0
    var right = count - 1
    while left<right {
      let mid = (left+right)/2
      let candidate = self[mid]
      if isOrderedBefore(candidate, value) {
        left = mid + 1
      }else if isOrderedBefore(value, candidate) {
        right = mid - 1
      }else {
        return mid
      }
    }
    return nil
  }
}

extension Array where Element: Comparable {
  func binarySearch(value: Element) -> Int? {
    return self.binarySearch(value, isOrderedBefore: <)
  }
}

//extension CollectionType where Index == Int {
//  public func binarySearch(value: Generator.Element, isOrderedBefore:(Generator.Element, Generator.Element) -> Bool) -> Index? {
//    var left = 0
//    var right = count - 1
//    while left<right {
//      let mid = (left+right)/2
//      let candidate = self[mid]
//      if isOrderedBefore(candidate, value) {
//        left = mid + 1
//      }else if isOrderedBefore(value, candidate) {
//        right = mid - 1
//      }else {
//        return mid
//      }
//    }
//    return nil
//
//  }
//}

extension CollectionType where Index: RandomAccessIndexType {
  public func binarySearch(value: Generator.Element, isOrderedBefore:(Generator.Element, Generator.Element) -> Bool) -> Index? {
    guard !isEmpty else { return nil }
    var left = startIndex
    var right = endIndex - 1
    
    while left <= right {
      let mid = left.advancedBy(left.distanceTo(right)/2)
      let candidate = self[mid]
      
      if isOrderedBefore(candidate, value) {
        left = mid + 1
      }else if isOrderedBefore(value, candidate) {
        right = mid - 1
      }else {
        return mid
      }
    }
    return nil
  }
}

extension CollectionType where Index: RandomAccessIndexType, Generator.Element: Comparable {
  func binarySearch(value: Generator.Element) -> Index? {
    return binarySearch(value, isOrderedBefore: <)
  }
}

let array = ["a", "b", "c", "d", "e", "f", "g"]
let reserve = array.reverse()
assert(reserve.binarySearch("g", isOrderedBefore: >) == reserve.startIndex)

//extension Array {
//  mutating func shuffleInPlace() {
//    for i in 0..<(count-1) {
//      let j = Int(arc4random_uniform(UInt32(count-i))) + i
//      guard i != j else { continue }
//      
//      swap(&self[i], &self[j])
//    }
//  }
//  
//  func shuffle() -> [Element] {
//    var clone = self
//    clone.shuffleInPlace()
//    return clone
//  }
//}

extension _SignedIntegerType {
  static func arc4random_uniform(upper_bound: Self) -> Self {
    precondition(upper_bound > 0 && upper_bound.toIntMax() < UInt32.max.toIntMax(), "arc4random_uniform only callable up to \(UInt32.max)" )
    return numericCast(Darwin.arc4random_uniform(numericCast(upper_bound)))
  }
}

extension Range {
  var arc4random: Element {
    return startIndex.advancedBy(Index.Distance.arc4random_uniform(count))
  }
}

extension MutableCollectionType where Index: RandomAccessIndexType {
  mutating func shuffleInPlace() {
    for i in indices.dropLast() {
      let j = (i..<endIndex).arc4random
      guard i != j else { continue }
      swap(&self[i], &self[j])
    }
  }
}

extension SequenceType {
  func shuffle() -> [Generator.Element] {
    var clone = Array(self)
    clone.shuffleInPlace()
    return clone
  }
}

array.shuffle()

//array.shuffleInPlace()

//: [Next](@next)