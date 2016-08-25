//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

//func sqrtLiter(guess: Double, x: Double) -> Double {
//  if goodEnough(guess, x: x) {
//    return guess
//  }else {
//    return sqrtLiter(improve(guess, x: x), x: x)
//  }
//}
//
//func goodEnough(guess: Double, x: Double) -> Bool {
//  if abs(guess * guess - x) < 0.001 {
//    return true
//  }else {
//    return false
//  }
//}
//
//func improve(guess: Double, x: Double) -> Double {
//  return (guess + x/guess)/2
//}
//
//
//func mysqrt(x: Double) {
//  sqrtLiter(x/2, x: x)
//}
//mysqrt(9)

//sqrtLiter(0.0000001, x: 0.0000001)

//mysqrt(900000000000000000000000000000000000000000000000000000000000000000000000000000000000)

func sqrtLiter(guess: Double, x: Double) -> Double {
  let newGuess = improve(guess, x: x)
  if goodEnough(oldGuess: guess, newGuess: newGuess) {
    return guess
  }else {
    return sqrtLiter(improve(guess, x: x), x: x)
  }
}

func goodEnough(oldGuess oldGuess: Double, newGuess: Double) -> Bool {
  if abs(newGuess - oldGuess)/oldGuess < 0.01 {
    return true
  }else {
    return false
  }
}

func improve(guess: Double, x: Double) -> Double {
  return (guess + x/guess)/2
}


func mysqrt(x: Double) {
  sqrtLiter(x/2, x: x)
}

sqrtLiter(0.0000001, x: 3)


do {
  
  func cubeIter(guess: Double, x: Double) -> Double {
    let newGuess = improveGuess(guess, x: x)
    if goodEnough(guess, newGuess: newGuess) {
      return guess
    }else {
      return cubeIter(newGuess, x: x)
    }
    
  }
  
  func goodEnough(oldGeuss: Double, newGuess: Double) -> Bool {
    if abs(newGuess - oldGeuss) / oldGeuss < 0.01 {
      return true
    }else {
      return false
    }
  }
  
  func improveGuess(oldGuess: Double, x: Double) -> Double {
    return (x/(oldGuess*oldGuess) + 2*oldGuess)/3
  }
  
  cubeIter(1, x: 3)
}

func cube(x: Double) -> Double {
  func cubeIter(guess: Double) -> Double {
    let newGuess = improveGuess(guess)
    if goodEnough(guess, newGuess: newGuess) {
      return guess
    }else {
      return cubeIter(newGuess)
    }
  }
  
  func goodEnough(oldGuess: Double, newGuess: Double) -> Bool {
    if abs(newGuess - oldGuess) / oldGuess < 0.001 {
      return true
    }else {
      return false
    }
  }
  
  func improveGuess(oldGuess: Double) -> Double {
    return (x/(oldGuess*oldGuess) + 2*oldGuess)/3
  }
  
  return cubeIter(x/2)
}

cube(10)




func cc(amount: Int, kindsOfCoins: Int) -> Int {
  if amount == 0 {
    return 1
  }
  if  amount < 0 || kindsOfCoins == 0 {
    return 0
  }
  return cc(amount, kindsOfCoins: kindsOfCoins - 1) + cc(amount - firstDenomination(kindsOfCoins), kindsOfCoins: kindsOfCoins)
}

func firstDenomination(kindsOfCoins: Int) -> Int {
  switch kindsOfCoins {
  case 1:
    return 1
  case 2:
    return 5
  case 3:
    return 10
  case 4:
    return 25
  case 5:
    return 50
  default:
    fatalError()
  }
}
func countChange(amount: Int) -> Int {
  return cc(amount, kindsOfCoins: 5)
}
//cc(100, kindsOfCoins: 5)


func f4(a: Int, b: Int, c: Int, count: Int) -> Int {
  if count == 0 {
    return a
  }else {
    return f4(b, b: c, c: c + 2*b + 3*a, count: count-1)
  }
}

func f44(n: Int) -> Int {
  return f4(0, b: 1, c: 2, count: n)
}

f44(4)

func pascal(row row: Int, col: Int) -> Int {
  guard col <= row && row >= 0 && col >= 0 else { fatalError("Input error") }
  if col == 1 {
    return 1
  }
  if (col == row) {
    return 1
  }
  return pascal(row: row - 1, col: col) + pascal(row: row-1, col: col-1)
}

pascal(row:5, col:2)



func p(x: Double) -> Double {
  return 3*x - 4*x*x*x
}

func sine(angle: Double) -> Double {
  if abs(angle) <= 0.1 {
    return angle
  }else {
    return p(sine(angle/3))
  }
}
sine(12.15)

func exptIter(b: Int, counter: Int, product: Int) -> Int {
  if counter == 0 {
    return product
  }else {
    return exptIter(b, counter: counter-1, product: counter*product)
  }
}

func fastExpt(b: Int, n: Int) -> Int {
  if n == 0 {
    return 1
  }
  if n % 2 == 0 {
    let temp = fastExpt(b, n: n/2)
    return temp * temp
  }else {
    return n * fastExpt(b, n: n-1)
  }
}

//: ## 1.16
//Tail recursive
func exptIter1_16(b: Int, n: Int, a: Int) -> Int {
  if n == 0 {
    return a
  }
  if n % 2 == 0 {
    return exptIter1_16(b*b, n: n/2, a: a)
  }else {
    return exptIter1_16(b, n: n-1, a: a*b)
  }
}



func fastExpt1_16(b: Int, n: Int) -> Int {
  return exptIter1_16(b, n: n, a: 1)
}

//: ## 1.17 1.8
func double(n: Int) -> Int {
  return n + n
}

func halve(n: Int) -> Int {
  return n/2
}

func muti(a: Int, b: Int) -> Int {
  if b == 0 {
    return 0
  }
  if b%2 == 0 {
//    return double(muti(a, b: halve(b)))
    let half = muti(a, b: b/2)
    return half + half
  }else {
    return muti(a, b: b-1) + a
  }
}

func mutiIter(a: Int, b: Int, productor: Int) -> Int {
  if b == 0 {
    return productor
  }
  if b%2 == 0 {
    return mutiIter(a+a, b: b/2, productor: productor)
  }else {
    return mutiIter(a, b: b-1, productor: productor+a)
  }
}

func fastMuti(a: Int, b: Int) -> Int {
  return mutiIter(a, b: b, productor: 0)
}

fastMuti(1, b: 5)


// GCD
func gcd(a a: Int, b: Int) -> Int {
  if b == 0 {
    return a
  }else {
    return gcd(a: b, b: a%b)
  }
}
gcd(a: 206, b: 40)
//: [Next](@next)

