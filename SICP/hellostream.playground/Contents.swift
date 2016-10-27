//: Playground - noun: a place where people can play

import Foundation

func memoProc<T>(proc: @escaping ()->T) -> (()->T) {
  var result: T? = nil
  return {
    if let result = result {
      return result
    }else {
      result = proc()
      return result!
    }
  }
}

func delay<T>(proc: @escaping ()->T) -> (()->T) {
  return memoProc {
    proc()
  }
}

func force<T>(delayed: @escaping ()->T) -> T {
  return delayed()
}

let delayed = delay {
  1+1
}
force(delayed: delayed)

//struct Stream<T> {
//  let car: T
//  let cdr: ()->T
//}
//
//func consStream<T>(_ car: T, _ cdr: @escaping ()->T) -> Stream<T> {
//  return Stream(car: car, cdr: { cdr() })
//}
//
//func carStream<T>(_ stream: Stream<T>) -> T {
//  return stream.car
//}
//
//func cdrStream<T>(_ stream: Stream<T>) -> T {
//  return force(delayed: stream.cdr)
//}
//
