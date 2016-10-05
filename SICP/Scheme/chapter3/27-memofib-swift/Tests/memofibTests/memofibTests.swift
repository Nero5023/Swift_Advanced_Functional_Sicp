import XCTest
@testable import memofib

func memoize<T: Hashable, R>(f: @escaping (T)->R) -> ((T)->R) {
  var table: [T: R] = [:]
  return { x in
    if let previousComputedResult = table[x] {
      return previousComputedResult
    }else {
      let result = f(x)
      table[x] = result
      return result
    }
  }
}


func memoFib(x: Int) -> Int {
  let closure: (Int)->Int = { n in
    switch n {
    case 0:
      return 0
    case 1:
      return 1
    default:
      return memoFib(x: (n-1)) + memoFib(x: (n-2))
    }
  }
  return memoize(f: closure)(x)
}


func fib(x: Int) -> Int {
  switch x {
  case 0:
    return 0
  case 1:
    return 1
  default:
    return fib(x: (x-1)) + fib(x: (x-2))
  }
}

class memofibTests: XCTestCase {
  
  
  
    func testMemoFib() {
      measure {
          memoFib(x: 30)
      }
    }
  
  func testFib() {
    measure {
      fib(x: 30)
    }
  }


    static var allTests : [(String, (memofibTests) -> () throws -> Void)] {
        return [
            ("testExample", testMemoFib),
        ]
    }
}
