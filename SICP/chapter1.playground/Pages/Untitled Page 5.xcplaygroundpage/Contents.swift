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

compose(fx: { $0*$0 }, gx: inc)(6)


//: ## 1.43

func repeated(fx fx: FunctionType, times: Int) -> FunctionType {
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

repeated(fx: cube, times: 3)(2)
repeatedIteration(fx: cube, times: 3)(2)

//: [Next](@next)
