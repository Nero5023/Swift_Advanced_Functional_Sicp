//: [Previous](@previous)

import Foundation
import UIKit

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

let array:[CGFloat] = [50.2, 59.8, 76.6, 100.5, 153.6, 178.1, 209.6, 277.1, 363.7, 518.4]


//array.map {
//    let percent = CGFloat.random(min: 0.15, max: 0.3)
//     return  $0*percent
//}
print(array.map { (x) -> String in
      let percent = CGFloat.random(min: 0.15, max: 0.3)
//    return Sx*percent
    return String(format: "%.1f", x*percent)
})


