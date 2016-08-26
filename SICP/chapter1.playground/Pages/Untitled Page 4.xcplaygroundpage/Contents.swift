//: [Previous](@previous)

import Foundation

//: # 1.3 用高阶函数做抽象

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


//: ## 1.35
// 黄金比例数
//fixedPoint(firstguess: 2.0) { x in
//  1 + 1/x
//}

//: ## 1.36
//非平均阻尼
fixedPoint(firstguess: 2) { x in
  log(1000)/log(x)
}
//平均阻尼
fixedPoint(firstguess: 2) { x in
  (log(1000)/log(x) + x)/2
}

func averageDamp(f: (Double)->Double) -> (Double)->Double {
  return { x in
    return (x + f(x))/2
  }
}


//: ## 1.37
// 递归版
func contFrac(k: Int, nFunc: (Int)->Double, dFunc: (Int)->Double) -> Double {
//  nFunc(k) / (dFunc(k)  )
  func cf(i: Int) -> Double {
    if i==k {
      return nFunc(i) / dFunc(i)
    }else {
      return nFunc(i) / (dFunc(i)+cf(i+1))
    }
  }
  
  return cf(1)
}

contFrac(10, nFunc: { _ in 1 }, dFunc: { _ in 1 })

// 迭代版 考虑先算什么再算什么
func contFracIteration(k: Int, nFunc: (Int)->Double, dFunc: (Int)->Double) -> Double {
  func iter(i i: Int, result: Double) -> Double {
    if i == 0 {
      return result
    }
    return iter(i: i-1, result: nFunc(i) / (dFunc(i) + result))
  }
  return iter(i: k, result: 0)
}

contFracIteration(11, nFunc: { _ in 1 }, dFunc: { _ in 1 })

// e - 2 = 
// contFrac 上面的这个过程 nfunc = { _ in 1 } , dfunc = 1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8

func calculate_e(k: Int) -> Double {
  func dfunc(k: Int) -> Double {
    let i = k/3 + 1
    return k % 3 == 2 ? Double(i*2) : Double(1)
  }
  return contFrac(k, nFunc: { _ in 1 }, dFunc: dfunc) + 2
}
calculate_e(11)

// 正切函数 连分式
func tan_cf(x x: Double, k: Int) -> Double {
  func dfunc(i: Int) -> Double {
    return Double(2*i - 1)
  }
  func nfunc(i: Int) -> Double {
    return i == 1 ? x : -x*x
  }
  return contFracIteration(k, nFunc: nfunc, dFunc: dfunc)
}

tan_cf(x: 10, k: 100)
tan(10.0)
tan_cf(x: 25, k: 100)
tan(25.0)


//: [Next](@next)
