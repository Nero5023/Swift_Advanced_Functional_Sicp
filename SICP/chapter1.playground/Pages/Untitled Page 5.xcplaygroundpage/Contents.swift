//: [Previous](@previous)

import Foundation

typealias FunctionType = (Double) -> Double

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

func averageDamp(f: (Double)->Double) -> (Double)->Double {
  return { x in
    return (x + f(x))/2
  }
}



// 牛顿法 f(x) = x - g(x)/dg(x)  
//dg(x) 导数

// dg(x) = (g(x+dx) - g(x)) / dx

func deriv(f: (Double)->Double) -> (Double)->Double {
  let dx = 0.00001
  return { x in
    (f(x+dx) - f(x)) / dx
  }
}

func cube(x: Double) -> Double {
  return x*x*x
}

deriv(cube)(5) // x^3 在 x=5 处的导数 3x^2 

//f(x) = x - g(x)/dg(x)
func newtonTransform(gx: (Double)->Double) -> (Double)->Double {
  return { x in
    x - gx(x)/deriv(gx)(x)
  }
}

func newtonMethod(guess: Double, gx: (Double)->Double) -> Double {
  return fixedPoint(firstguess: guess, function: newtonTransform(gx))
}


func fixedPointOfTransform(guess guess: Double, gx: (Double)->Double, transform: ((Double)->Double) -> ((Double)->Double)) -> Double {
  return fixedPoint(firstguess: guess, function: transform(gx))
}

func sqrtWithNew(x: Double) -> Double {
  return fixedPointOfTransform(guess: 1.0, gx: { y in
      x/y
    }, transform: averageDamp)
}

func sqrtWithNew2(x: Double) -> Double {
  return fixedPointOfTransform(guess: 1.0, gx: { y in
    y*y - x
    }, transform: newtonTransform)
}

sqrtWithNew2(2)


//: ## 1.40

func cubic(a a: Double, b: Double, c: Double) -> FunctionType {
  return { x in
    return x*x*x + a*x*x + b*x + c
  }
}

newtonMethod(1, gx: cubic(a: 2 , b: 5, c: 5))

//: ## 1.41
func doubleF(f: FunctionType) -> FunctionType {
  return { x in
    return f(f(x))
  }
}

func doubleF(f: FunctionType -> FunctionType) -> FunctionType->FunctionType {
  return { x in
    return f(f(x))
  }
}


func inc(x: Double) -> Double {
  return x + 1
}
//
doubleF(doubleF(doubleF))(inc)(5)

//: ## 1.42

func compose(fx fx: FunctionType, gx: FunctionType) -> FunctionType {
  return { x in
    fx(gx(x))
  }
}

func compose(fx fx: FunctionType->FunctionType, gx: FunctionType->FunctionType) -> FunctionType->FunctionType {
  return { x in
    fx(gx(x))
  }
}


compose(fx: { $0*$0 }, gx: inc)(6)


//: ## 1.43

func repeated(fx fx: FunctionType, times: Int) -> FunctionType {
  if times == 1 {
    return fx
  }
  return compose(fx: fx, gx: repeated(fx: fx, times: times-1))
}

func repeated(fx fx: FunctionType->FunctionType, times: Int) -> FunctionType->FunctionType {
  if times == 1 {
    return fx
  }
  return compose(fx: fx, gx: repeated(fx: fx, times: times-1))
}

func repeatedIteration(fx fx: FunctionType, times: Int) -> FunctionType {
  func iter(i: Int, repeatFunc: FunctionType) -> FunctionType {
    if i == times {
      return repeatFunc
    }
    return iter(i+1, repeatFunc: compose(fx: fx, gx: repeatFunc))
  }
  return iter(1, repeatFunc: fx)
}

func repeatedIteration(fx fx: FunctionType->FunctionType, times: Int) -> FunctionType->FunctionType {
  func iter(i: Int, repeatFunc: FunctionType->FunctionType) -> FunctionType->FunctionType{
    if i == times {
      return repeatFunc
    }
    return iter(i+1, repeatFunc: compose(fx: fx, gx: repeatFunc))
  }
  return iter(1, repeatFunc: fx)
}

repeated(fx: cube, times: 3)(2)
repeatedIteration(fx: cube, times: 3)(2)

//: ## 1.44

func smooth(fx fx: FunctionType) -> FunctionType {
  let dx = 0.0001
  return { x in
    (fx(x) + fx(x-dx) + fx(x+dx)) / 3
  }
}

func square(x: Double) -> Double {
  return x*x
}

func smoothNTimes(fx: FunctionType, times: Int) -> FunctionType {
  let nRepeat = repeatedIteration(fx: smooth, times: times)
  return nRepeat(fx)
}

//repeated(fx: smooth, times: 10)(square)(5)
//

//: ## 1.45
func expt(base base: Double, n: Int) -> Double {
  if n == 0 {
    return 1
  }
  return repeated(fx: { x in
      x*base
    }, times: n)(1)
}

expt(base: 2, n: 2)

func averageDampNTimes(fx: FunctionType, times: Int) -> FunctionType {
  return repeated(fx: averageDamp, times: times)(fx)
}

//smoothNTimes(square, times: 10)(5)

// n 是 次方，dampTimes 平均阻尼变化次数
func damped_nth_root(n n: Int, dampTimes: Int) -> FunctionType {
  return { x in
    fixedPoint(firstguess: 1.0, function: averageDampNTimes({ y in
        x/expt(base: y, n: n-1)
      }, times: dampTimes))
  }
}

//damped_nth_root(n: <#T##Int#>, dampTimes: <#T##Int#>)
func sqrtRoot(x: Double) -> Double {
  return damped_nth_root(n: 2, dampTimes: 1)(x)
}
sqrtRoot(9)

//要使得计算 n次方根的不动点收敛，最少需要 ⌊lgn⌋ 次平均阻尼
//取整
func mylog(x: Double) -> Int {
  if x/2 > 1 {
    return 1 + mylog(x/2)
  }else if x/2 < 1 {
    return 0
  }else {
    return 1
  }
}

func n_th_root(n: Int) -> FunctionType {
  return damped_nth_root(n: n, dampTimes: mylog(Double(n)))
}


//: ## 1.46
// 它接受一个用于检测猜测值是否足够好的函数(close-enough?)，以及一个用于改进猜测值的函数(improve)
func iteractiveImprove(closeEnough closeEnough: (Double, Double)->Bool, improve: FunctionType) -> FunctionType {
  func tryGuess(guess: Double) -> Double {
    let next = improve(guess)
    if closeEnough(guess, next) {
      return next
    }
    return tryGuess(next)
  }
  return tryGuess
}


func sqrt(x x: Double, guess: Double) -> Double {
  func goodEnough(oldGeuss: Double, newGuess: Double) -> Bool {
    if abs(newGuess - oldGeuss) / oldGeuss < 0.01 {
      return true
    }else {
      return false
    }
  }
  
  func improve(guess: Double) -> Double {
    return (guess + x/guess)/2
  }
  return iteractiveImprove(closeEnough: goodEnough, improve: improve)(guess)
}

func fixedPoint_refactor(firstguess firstguess: Double, function: (Double)->Double) -> Double {
  func closeEnough(v1: Double, _ v2: Double) -> Bool {
    let tolerance = 0.000001
    return abs(v1-v2) < tolerance
  }
  
  func improve(x: Double) -> Double {
    return function(x)
  }
  return iteractiveImprove(closeEnough: closeEnough, improve: improve)(firstguess)
}



//: [Next](@next)
