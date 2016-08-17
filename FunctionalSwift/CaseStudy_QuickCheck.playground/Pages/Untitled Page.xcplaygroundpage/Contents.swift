//: Playground - noun: a place where people can play

import UIKit

protocol Arbitrary {
  static func arbitrary() -> Self
}

extension Int: Arbitrary {
  static func arbitrary() -> Int {
    return Int(arc4random())
  }
}

extension Int {
  static func random(from from: Int, to: Int) -> Int {
    return from + (Int(arc4random()) % (to - from))
  }
}

extension Character: Arbitrary {
  static func arbitrary() -> Character {
    return Character(UnicodeScalar(Int.random(from: 65, to: 90)))
  }
}


func tabulate<A>(times: Int, transform: Int->A) -> [A] {
  return (0..<times).map(transform)
}

extension String: Arbitrary {
  static func arbitrary() -> String {
    let randomLength = Int.random(from: 0, to: 40)
    let randomCharacters = tabulate(randomLength) { _ in
      Character.arbitrary()
    }
    return String(randomCharacters)
  }
}

let numberOfIterations =  10
func check1<A: Arbitrary>(message: String, _ property: A->Bool) -> () {
  for _ in 0..<numberOfIterations {
    let value = A.arbitrary()
    guard property(value) else {
      print("\"\(message)\" doesn't hold:\(value)")
      return
    }
  }
  print("\"\(message)\" passed \(numberOfIterations) tests")
}

//extension CGSize {
//  var area: CGFloat {
//    return width*height
//  }
//}
//
//extension CGSize: Arbitrary {
//  static func arbitrary() -> CGSize {
//    return CGSize(width: CGFloat.a, height: <#T##CGFloat#>)
//  }
//}

check1("Every string starts with Hello") { (s: String) in
  s.hasPrefix("Hello")
}

protocol Smaller {
  func smaller() -> Self?
}

extension Int: Smaller {
  func smaller() -> Int? {
    return self == 0 ? nil : self/2
  }
}

extension String: Smaller {
  func smaller() -> String? {
    return isEmpty ? nil : String(characters.dropFirst())
  }
}

Int.random(from: 450, to: 500)



//: [Next](@next)
