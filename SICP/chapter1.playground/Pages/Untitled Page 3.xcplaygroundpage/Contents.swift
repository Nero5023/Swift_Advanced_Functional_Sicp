//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//从a到b的各个整数之和 a加到b
func sumIntegers(a: Int, b: Int) -> Int {
  if a > b {
    return 0
  }else {
    return a + sumIntegers(a+1, b: b)
  }
}

sumIntegers(1, b: 10)

func sum(start start: Int, end: Int, term: (Int)->(Int), next: (Int)->(Int)) -> Int {
  if start > end {
    return 0
  }else {
    return term(start) + sum(start: next(start), end: end, term: term, next: next)
  }
}

func identity(x: Int) -> Int {
  return x
}

func inc(x: Int) -> Int {
  return x+1
}

func sumOfIntegers(start: Int, end: Int) -> Int {
  return sum(start: start, end: end, term: identity, next: inc)
}
sumOfIntegers(1, end: 10)


func sumdouble(start start: Double, end: Double, term: (Double)->(Double), next: (Double)->(Double)) -> Double {
  if start > end {
    return 0
  }else {
    return term(start) + sumdouble(start: next(start), end: end, term: term, next: next)
  }
}

func integral(start start: Double, end: Double, dx: Double, f: (Double)->(Double)) -> Double {
  func next(x: Double) -> Double {
    return x + dx
  }
  return dx * sumdouble(start: (start+dx/2), end: end, term: f, next: next)
}

func cube(x: Double) -> Double {
  return x*x*x
}

integral(start: 0, end: 1, dx: 0.001, f: cube)
// 定积分
func xpsIntegral(start start: Double, end: Double, n: Double, f: (Double)->(Double)) -> Double {
  let h = (end-start)/n
  func xpsIntegralTerm(k: Double) -> Double {
    func factor(k: Double) -> Double {
      if k == 0 || k == n {
        return 1
      }
      if k%2==1 {
        return 4
      }else {
        return 2
      }
    }
    return f(start + k*h) * factor(k)
  }
  
  return h/3.0 * sumdouble(start: 0, end: n, term: xpsIntegralTerm) { $0 + 1 }
  
}

xpsIntegral(start: 0, end: 1, n: 100, f: cube)

//迭代递归（尾递归）
func sumIteration(a a: Double, b: Double, term: (Double)->(Double), next: (Double)->(Double)) -> Double {
  func iter(a: Double, result: Double) -> Double {
    if a > b {
      return result
    }else {
      return iter(next(a), result: term(a)+result)
    }
  }
  return iter(a, result: 0)
}

print(sumIteration(a: 1, b: 10, term: { $0 }, next: { $0+1 }))


func product(a: Double, b: Double, term: (Double)->(Double) ,next: (Double)->(Double)) -> Double {
  if a > b {
    return 1
  }
  return term(a) * product(next(a), b: b, term: term, next: next)
}

print(product(3, b: 10000, term: { x in
  (x-1.0)*(x+1.0)/(x*x)
  }, next: {
    $0 + 2
})*4)

func productIteration(a a: Double, b: Double, term: (Double)->(Double), next: (Double)->(Double)) -> Double {
  func iter(a a: Double, result: Double) -> Double {
    if a > b {
      return result
    }
    return iter(a: next(a), result: result*term(a))
  }
  return iter(a: a, result: 1)
}

func accumulate(a a: Double, b: Double, nullValue: Double, combiner: (Double, Double)->Double, term: (Double)->Double, next: (Double)-> Double) -> Double {
  if a > b {
    return nullValue
  }
  return combiner(a, accumulate(a: next(a), b: b, nullValue: nullValue, combiner: combiner, term: term, next: next))
}

func accumulateIteration(a a: Double, b: Double, nullValue: Double, combiner: (Double, Double)->Double, term: (Double)->Double, next: (Double)-> Double) -> Double {
  func iter(a a: Double, result: Double) -> Double {
    if a>b {
      return result
    }
    return iter(a: next(a), result: combiner(term(a), result))
  }
  return iter(a: a, result: nullValue)
}

func filteredAccumulate(a a: Double, b: Double, nullValue: Double, combiner: (Double, Double)->Double, term: (Double)->Double, next: (Double)-> Double, isValid: (Double)->Bool) -> Double {
  if a > b {
    return nullValue
  }
  return combiner(isValid(a) ? term(a) : nullValue, filteredAccumulate(a: next(a), b: b, nullValue: nullValue, combiner: combiner, term: term, next: next, isValid: isValid))
}

func filteredAccumulateIteration(a a: Double, b: Double, nullValue: Double, combiner: (Double, Double)->Double, term: (Double)->Double, next: (Double)-> Double, isValid: (Double)->Bool) -> Double {
  func iter(a a: Double, result: Double) -> Double {
    if a > b {
      return result
    }
    let combined = isValid(a) ? term(a) : nullValue
    return iter(a: a, result: combiner(combined, result))
  }
  return iter(a: a, result: nullValue)
}


//----------------------------------------------
//素数
func findDivisor(num: Int, testDivisor: Int) -> Int {
  if testDivisor*testDivisor > num {
    return num
  }
  if num % testDivisor == 0{
    return testDivisor
  }
  return findDivisor(num, testDivisor: testDivisor+1)
}

func smallestDivisor(num: Int) -> Int {
  return findDivisor(num, testDivisor: 2)
}

func isPrime(num: Int) -> Bool {
  return smallestDivisor(num) == num
}
//----------------------------------------------

func sumPrime(a a: Double, b: Double) -> Double {
  return filteredAccumulate(a: a, b: b, nullValue: 0, combiner: +, term: { $0 }, next: { $0+1 }, isValid: { isPrime(Int($0))})
}

sumPrime(a: 2, b: 10)

//: [Next](@next)
