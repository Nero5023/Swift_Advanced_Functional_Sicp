//: [Previous](@previous)

import Foundation

// 函数的解 区间折半法
func search(negPoint negPoint: Double, posPoint: Double, function: (Double)->Double) -> Double {
  let midPoint = (negPoint + posPoint) / 2.0
  if closeEnough(negPoint, y: posPoint) {
    return midPoint
  }
  let testValue = function(midPoint)
  if testValue > 0 {
    return search(negPoint: negPoint, posPoint: midPoint, function: function)
  }else if testValue < 0 {
    return search(negPoint: midPoint, posPoint: posPoint, function: function)
  }else {
    return midPoint
  }
  
}

func closeEnough(x: Double, y: Double) -> Bool {
  return abs(x-y) < 0.0001
}

//search(4, posPoint: 2, function: sin)
func haltIntervalMethod(a a: Double, b: Double, function: (Double)->Double) -> Double {
  let aValue = function(a)
  let bValue = function(b)
  if aValue > 0 && bValue < 0 {
    return search(negPoint: b, posPoint: a, function: function)
  }else if aValue < 0 && bValue > 0 {
    return search(negPoint: a, posPoint: b, function: function)
  }else {
    fatalError("wrong guess")
  }
}

haltIntervalMethod(a: 2, b: 4 , function: sin)


// 函数不动点

func fixedPoint(firstguess firstguess: Double, function: (Double)->Double) -> Double {
  func closeEnough(v1: Double, _ v2: Double) -> Bool {
    let tolerance = 0.000001
    return abs(v1-v2) < tolerance
  }
  func tryGuess(guess: Double) -> Double {
    let next = function(guess)
    if closeEnough(next, guess) {
      return next
    }else {
      next
      return tryGuess(next)
    }
  }
  return tryGuess(firstguess)
}

//fixedPoint(firstguess: 1.0) {
//  sin($0) + cos($0)
//}

// 猜测 震荡 一直不趋近
//func sqrt0(x: Double) -> Double {
//  return fixedPoint(firstguess: 1.0) { y in
//    return x/y
//  }
//}
//sqrt0(2)

// 平均根
// 平方根
func sqrtNew(x: Double) -> Double {
  return fixedPoint(firstguess: 1.0) { y in
    (y + x/y)/2
  }
}
//sqrtNew(2)

// 黄金比例数
//fixedPoint(firstguess: 2.0) { x in
//  1 + 1/x
//}

//非平均阻尼
fixedPoint(firstguess: 2) { x in
  log(1000)/log(x)
}
//平均阻尼
fixedPoint(firstguess: 2) { x in
  (log(1000)/log(x) + x)/2
}