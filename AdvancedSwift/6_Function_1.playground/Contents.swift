//: Playground - noun: a place where people can play

import UIKit

//: # Flexibility through Functions

let last = "lastName", first = "firstName"

let people = [
  [first: "Jo", last: "Smith"],
  [first: "Joe", last: "Smith"],
  [first: "Joe", last: "Smyth"],
  [first: "Joanne", last: "Smith"],
  [first: "Robert", last: "Jones"]
]

let lastDescriptor = NSSortDescriptor(key: last, ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
let firstDescriptor = NSSortDescriptor(key: first, ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))

let descriptors = [lastDescriptor, firstDescriptor]

let sortedArray = (people as NSArray).sortedArrayUsingDescriptors(descriptors)

let sortedArray2 = people.sort {p0, p1 in
  let left = [p0[last], p1[first]]
  let right = [p1[last], p1[first]]
  return left.lexicographicalCompare(right) {
    guard let l = $0 else { return false }
    guard let r = $1 else { return true }
    return l.localizedCaseInsensitiveCompare(r) == .OrderedAscending
  }
}



extension Optional {
  func compare(rhs: Wrapped?, _ comparator: Wrapped -> Wrapped -> NSComparisonResult) -> Bool {
    switch (self, rhs) {
    case (nil, nil), (_?, nil):
      return false
    case (nil, _?): return true
    case let (l?,r?): return comparator(l)(r) == .OrderedAscending
    }
  }
}

//: # Curried Functions
// Following two lines is the same
String.localizedCaseInsensitiveCompare("Hello")("world") // curried functions
"Hello".localizedCaseInsensitiveCompare("world")

let a: String? = "Fred"
let b: String? = "Bob"
a.compare(b, String.localizedCaseInsensitiveCompare)

func isMultipleOf(n n: Int) -> Int -> Bool {
  return { i in i%n == 0 }
}

let nums = 1...10
let isEven = isMultipleOf(n: 2)
let evens = nums.filter(isMultipleOf(n: 2))

//: # Functions as Data

func lexicograhphicalCompare<T>(comparators: [(T,T)->Bool]) -> (T,T)->Bool  {
  return { lhs, rhs in
    for isOrderedBefore in comparators {
      if isOrderedBefore(lhs, rhs) { return true }
      if isOrderedBefore(rhs, lhs) { return false }
    }
    return false
  }
}
//
let comparators: [([String: String], [String: String]) -> Bool] = [
  { $0[last].compare($1[last], String.localizedCompare) },
  { $0[first].compare($1[last], String.localizedCompare) }
]

let sortedArray3 = people.sort(lexicograhphicalCompare(comparators))

//: # Local Functions and Variable Capture
extension Array where Element: Comparable {
  private mutating func merge(low: Int, _ middle: Int, _ high: Int) {
    var temp: [Element] = []
    var i = low, j = middle
    while i != middle && j != high {
      if self[j] < self[i] {
        temp.append(self[j])
        j += 1
      }else {
        temp.append(self[i])
        i += 1
      }
    }
    
    temp.appendContentsOf(self[i..<middle])
    temp.appendContentsOf(self[j..<high])
    replaceRange(low..<high, with: temp)
  }
  
  mutating func mergeSortInPlace() {
    let n = count
    var size = 1
    while size < n {
      for lo in 0.stride(to: n-size, by: size*2) {
        merge(lo, lo+size, min(lo+size*2, n))
      }
      size *= 2
    }
  }
}

var numbers = [5,1,2,3,4]
numbers.mergeSortInPlace()
print(numbers)


