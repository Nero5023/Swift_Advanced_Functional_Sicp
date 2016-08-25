//: [Previous](@previous)

import Foundation

// 素数检测

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


//isPrime(67)

// 费马测试

extension Int {
  public static func random(min min: Int, max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max - min + 1))) + min
  }
}

func square(n: Int) -> Int {
  return n*n
}

func expmod(base: Int, exp: Int, divisor: Int) -> Int {
  if exp == 0 { return 1 }
  if exp % 2 == 0 {
    return square(expmod(base, exp: exp/2, divisor: divisor)) % divisor
  }else {
    return ((base%divisor) * expmod(base, exp: exp-1, divisor: divisor)) % divisor
  }
}

// if true num must not be prime, else it may be prime
// 如果真则比不为素数，否侧可能是素数
func fermatTest(num: Int) -> Bool {
  func tryIt(a: Int) -> Bool {
    return expmod(a, exp: num, divisor: num) == a
  }
  return tryIt(Int.random(min: 1, max: num-1))
}

func fastPrime(num: Int, times: Int) -> Bool {
  if times == 0 {
    return true
  }
  if fermatTest(num) {
    return fastPrime(num, times: times-1)
  }else {
    return false
  }
}

fastPrime(99, times: 67)

//练习 1.21
smallestDivisor(19999)

func timePrimeTest(num: Int) {
  print("")
//  print(num)
  startPrimeTest(num, start: NSDate())
}

func startPrimeTest(num: Int, start: NSDate)  {
  if (isPrime(num)) {
    let end = NSDate()
    reportPrime(end.timeIntervalSinceDate(start))
  }
}

func reportPrime(elapsed: NSTimeInterval) {
  print("****")
  print(elapsed)
}

func nextOdd(num: Int) -> Int {
  if num%2==0 {
    return num+1
  }else {
    return num+2
  }
}


func findDivisor2(num: Int, testDivisor: Int) -> Int {
  if testDivisor*testDivisor > num {
    return num
  }
  if num%testDivisor == 0 {
    return testDivisor
  }else {
    return findDivisor2(num, testDivisor: nextOdd(testDivisor))
  }
}

func smallestDivisor2(num: Int) -> Int {
  return findDivisor2(num, testDivisor: 2)
}

func isPrime2(num: Int) -> Bool {
  return smallestDivisor2(num) == num
}


func continuePrime(num: Int, count: Int) {
  if count == 0 {
    print("are primes!")
    return
  }
  if isPrime(num) {
    print(num)
    continuePrime(nextOdd(num), count: count-1)
  }else {
    continuePrime(nextOdd(num), count: count)
  }
}
//continuePrime(1000, count: 3)

func searchForPrime(num: Int) {
  let start = NSDate()
  continuePrime(num, count: 3)
  let end = NSDate()
  print(end.timeIntervalSinceDate(start))
  print("")
}



func continuePrime2(num: Int, count: Int) {
  if count == 0 {
    print("are primes!")
    return
  }
  if isPrime2(num) {
    print(num)
    continuePrime2(nextOdd(num), count: count-1)
  }else {
    continuePrime2(nextOdd(num), count: count)
  }
}

func searchForPrime2(num: Int) {
  let start = NSDate()
  continuePrime2(num, count: 3)
  let end = NSDate()
  print(end.timeIntervalSinceDate(start))
  print("")
}

//searchForPrime(10000)
//searchForPrime2(10000)
//searchForPrime(100000)
//searchForPrime2(100000)
//searchForPrime(1000000)
//searchForPrime2(1000000)
//searchForPrime(10000000)
//searchForPrime2(10000000)

expmod(1000000000, exp: 1000000000, divisor: 3)

func expmod2(base: Int, exp: Int, divisor: Int) -> Int {
  func fastExpt(base: Int, exp: Int) -> Int {
    if exp % 2 == 0 {
      return fastExpt(base*base, exp: exp/2)
    }else {
      return fastExpt(base, exp: exp-1)*base
    }
  }
  return fastExpt(base, exp: exp) % divisor
}
//expmod(1000000000, exp: 1000000000, divisor: 3) //溢出


func fermatTestNotRandom(num: Int, testDivisor: Int) -> Bool {
  return expmod(testDivisor, exp: num, divisor: num) == testDivisor
}

//用费马检测所有的可能
func checkAllIfIsPrime(num: Int, divisor: Int) -> Bool {
  if divisor*divisor > num {
    return true
  }
  if fermatTestNotRandom(num, testDivisor: divisor) {
    return checkAllIfIsPrime(num, divisor: divisor+1)
  }else {
    return false
  }
}

checkAllIfIsPrime(561, divisor: 2)
isPrime(561)

//: [Next](@next)