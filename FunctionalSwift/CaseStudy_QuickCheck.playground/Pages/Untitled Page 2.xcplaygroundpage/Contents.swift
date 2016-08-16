//: [Previous](@previous)

import Foundation

let numberOfIterations =  10

protocol Smaller {
  func smaller() -> Self?
}

protocol Arbitrary:Smaller {
  static func arbitrary() -> Self
}


func iterateWhile<A>(condition: A->Bool, initial: A, next: A->A?) -> A {
  if let x = next(initial) where condition(x) {
    return iterateWhile(condition, initial: x, next: next)
  }
  return initial
}

func check2<A: Arbitrary>(message: String, _ property: (A)->Bool) -> () {
  for _ in 0..<numberOfIterations {
    let value = A.arbitrary()
    guard property(value) else {
      let closure: (A)->Bool = {!property($0)}
      let smallerValue = iterateWhile(closure, initial: value) {
        $0.smaller()
      }
      print("\"\(message)\"doesn't hold: \(smallerValue)")
      return
    }
  }
  print("\"\(message)\" passed \(numberOfIterations)")
}

