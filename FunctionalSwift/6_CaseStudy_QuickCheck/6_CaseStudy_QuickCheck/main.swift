//
//  main.swift
//  6_CaseStudy_QuickCheck
//
//  Created by Nero Zuo on 16/8/16.
//  Copyright © 2016年 Nero. All rights reserved.
//

import Foundation

let numberOfIterations =  10

protocol Smaller {
   func smaller() -> Self?
}

protocol Arbitrary:Smaller {
  static func arbitrary() -> Self
}

extension Int: Arbitrary {
  static func arbitrary() -> Int {
    return Int(arc4random())
  }
  
  func smaller() -> Int? {
    return self == 0 ? nil : self/2
  }
  
  static func random(from from: Int, to: Int) -> Int {
    return from + (Int(arc4random()) % (to - from))
  }
}

func tabulate<A>(times: Int, transform: Int->A) -> [A] {
  return (0..<times).map(transform)
}

extension Character: Arbitrary {
  static func arbitrary() -> Character {
    return Character(UnicodeScalar(Int.random(from: 65, to: 90)))
  }
  
  func smaller() -> Character? {
    return nil
  }
}

extension String: Arbitrary {

  static func arbitrary() -> String {
    let randomLength = Int.random(from: 0, to: 40)
    let randomCharacters = tabulate(randomLength) { _ in
      Character.arbitrary()
    }
    return String(randomCharacters)
  }
  
  func smaller() -> String? {
    return isEmpty ? nil : String(characters.dropFirst())
  }
}

extension CGFloat {
  public static func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
  }
  public static func random(min min: CGFloat, max: CGFloat) -> CGFloat {
    assert(min < max)
    return CGFloat.random() * (max - min) + min
  }
  
  public static func randomSign() -> CGFloat {
    return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
  }
  
}

extension CGFloat: Arbitrary {
  
  
  static func arbitrary() -> CGFloat {
    return CGFloat.random(min: 0, max: CGFloat.max) * CGFloat.randomSign()
  }
  func smaller() -> CGFloat? {
    return nil
  }
}

extension CGSize {
  var area: CGFloat {
    return width * height
  }
}

extension CGSize: Arbitrary {
  static func arbitrary() -> CGSize {
    return CGSize(width: CGFloat.arbitrary(), height: CGFloat.arbitrary())
  }
  func smaller() -> CGSize? {
    return nil
  }
}


func iterateWhile<A>(condition: A->Bool, initial: A, next: A->A?) -> A {
  if let x = next(initial) where condition(x) {
    return iterateWhile(condition, initial: x, next: next)
  }
  return initial
}

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


func qsort(array: [Int]) -> [Int] {
  if array.isEmpty {
    return []
  }
  var array = array
  let pivot = array.removeAtIndex(0)
  let lesser = array.filter{ $0 < pivot }
  let greater = array.filter{ $0 > pivot }
  return qsort(lesser) + [pivot] + qsort(greater)
}

extension Array: Smaller {
  func smaller() -> [Element]? {
    guard !isEmpty else { return nil }
    return Array(dropFirst())
  }
}

extension Array where Element: Arbitrary {
  static func arbitrary() -> [Element] {
    let randomLength = Int(arc4random() % 50)
    return tabulate(randomLength) { _ in
      Element.arbitrary()
    }
  }
}


struct ArbitaryInstance<T> {
  let arbitrary: ()->T
  let smaller: T->T?
}

func checkHelper<A>(arbitraryInstance: ArbitaryInstance<A>, _ property: A->Bool, _ message: String) -> () {
  for _ in 0..<numberOfIterations {
    let value = arbitraryInstance.arbitrary()
    guard property(value) else {
      let smallerValue = iterateWhile({!property($0)}, initial: value, next: arbitraryInstance.smaller)
      print("\"\(message)\"doesn't hold: \(smallerValue)")
      return
    }
  }
  print("\"\(message)\" passed \(numberOfIterations)")
}

func check<X: Arbitrary>(message: String, property: X->Bool) {
  let instance = ArbitaryInstance(arbitrary: X.arbitrary, smaller: { $0.smaller() })
  checkHelper(instance, property, message)
}

func check<X: Arbitrary>(message: String, property: [X]->Bool) {
  let instance = ArbitaryInstance(arbitrary: Array.arbitrary, smaller: { (x: [X]) in x.smaller() })
  checkHelper(instance, property, message)
}

check("qsort should behave like sort") { (x: [Int]) -> Bool in
  let array1 = qsort(x)
  let array2 = x.sort(<)
  return array1 == array2
}

