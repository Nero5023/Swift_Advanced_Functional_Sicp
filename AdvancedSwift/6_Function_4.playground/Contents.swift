//: Playground - noun: a place where people can play

import UIKit

//: # Automatic Closures and Memory

// using closure to fake short-circuiting
// 可以只判断前面，不判断后面的
//“evaluate the arguments when really needed” 作用 必要时才评估参数

func and(l:Bool, _ r:()->Bool) -> Bool {
  guard l else { return false }
  return r()
}

let evens: [Int] = []

if and(!evens.isEmpty, { evens[0] > 10 }) {
  
}

// @autoclosure “automatically create a closure around an argument”
// 一个带有参数的closure

func and(l: Bool, @autoclosure _ r:()->Bool) -> Bool {
  guard l else { return false }
  return r()
}

if and(!evens.isEmpty, evens[0] > 10) {
  
}

//: # The noescope annotation

//@noescape transform: (Self.Generator.Element
// “once map is done, the closure is not referenced any longer”
evens.map { _ in 1 }


// @autoclosure 默认是noescape
// @autoclosure(escaping). This can be useful when working with asynchronous code.

