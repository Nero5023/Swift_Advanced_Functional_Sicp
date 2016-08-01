//: [Previous](@previous)

import Foundation

//: # Protocol Internals

//: ## Protocols and  Generics

func f(x: CustomStringConvertible) { }
func g<T: CustomStringConvertible>(x: T){ }

// 一般有范型时候，可以返回这个类型，而protocol不行
func myAbs<T: SignedNumberType>(x: T) -> T {
  if x < 0 {
    return -x
  }else {
    return x
  }
}

extension SignedNumberType {
  var myAbs: Self {
    if self<0 {
      return -self
    }else {
      return self
    }
  }
}

//: ## Protocols Internals

func takesProtocol(x: CustomStringConvertible) {
  print(sizeofValue(x))
}

func takesPlaceholder<T: CustomStringConvertible>(x: T) {
  print(sizeofValue(x))
}

// print 40
takesProtocol(1 as Int16)

//print 2
takesPlaceholder(1 as Int16)

class MyClass: CustomStringConvertible {
  var description: String { return "MyClass" }
}

// print 40
takesProtocol(MyClass())

// print 8
takesPlaceholder(MyClass())


extension CustomStringConvertible {
  func asExtension() {
    print(sizeofValue(self))
  }
}

// print 2
(1 as Int16).asExtension()

// print 8
MyClass().asExtension()


func dumpCustomStringConvertible(c: CustomStringConvertible) {
  var p = c
  withUnsafePointer(&p) { ptr -> Void in
    let intPtr = UnsafePointer<Int>(ptr)
    for i in 0.stride(to: sizeof(CustomStringConvertible)/8, by: 1) {
      print("\(i):\t0x\(String(intPtr[i], radix: 16))")
    }
  }
}

let i = Int(0xb1ab1ab1a)
dumpCustomStringConvertible(i)


// 方法二
struct CustomStringConvertibleBitCast {
  var test0: Int64
  var test1: Int64
  var test2: Int64
  var test3: Int64
  var test4: Int64
}

func unsafeToCustomStringConvertibleBitCast(x: CustomStringConvertible) {
  
  let test = unsafeBitCast(x, CustomStringConvertibleBitCast.self)
  print(test)

}

unsafeToCustomStringConvertibleBitCast(Int(0xb1ab1ab1a))

struct FourInts: CustomStringConvertible {
  var a = 0xaaaa
  var b = 0xbbbb
  var c = 0xcccc
  var d = 0xdddd
  var description: String { return String(a,b,c,d) }
}
dumpCustomStringConvertible(FourInts())


func dumpCustomStringConvertible<T>(p: CustomStringConvertible, type: T.Type) {
  var p = p
  withUnsafePointer(&p) { ptr -> Void in
    let intPtr = UnsafePointer<Int>(ptr)
    for i in 0.stride(to: sizeof(CustomStringConvertible)/8, by: 1) {
        print("\(i):\t0x\(String(intPtr[i], radix: 16))")
    }
    if sizeof(T) > 24 {
      let valPtr = UnsafePointer<T>(bitPattern: Int(intPtr.memory))
      print("value at pointer:\(valPtr.memory)")
    }
  }
}

dumpCustomStringConvertible(FourInts(), type: FourInts.self)

protocol Incrementable {
  var x: Int { get }
  mutating func inc()
}

struct S: Incrementable {
  var x = 0
  mutating func inc( ) {
    x+=1
  }
}

var p1: Incrementable = S()
var p2 = p1
p1.inc()
p1.x
p2.x

//: ## Performance Implications

protocol NumbserGeneratorType {
  mutating func generateNumbser() -> Int
}

struct RandomGenerator: NumbserGeneratorType {
  func generateNumbser() -> Int {
    return Int(arc4random_uniform(10))
  }
}



struct IncrementingGenerator: NumbserGeneratorType {
  var n: Int
  init(start: Int) { n = start }
  mutating func generateNumbser() -> Int {
    n+=1
    return n
  }
}

struct ConstantGenerator: NumbserGeneratorType {
  let n: Int
  init(constant: Int) { n = constant }
  func generateNumbser() -> Int {
    return n
  }
}

func generateUsingProtocol(g: NumbserGeneratorType, count: Int) -> Int {
  var generator = g
  return 0.stride(to: count, by: 1).reduce(0) { total, _ in
    total &+ generator.generateNumbser()
  }
}

func generateUsingGeneric<T: NumbserGeneratorType>(g: T, count: Int) -> Int {
  var generator = g
  return 0.stride(to: count, by: 1).reduce(0) { total, _ in
    total &+ generator.generateNumbser()
  }
}

//: ## Dynamic Dispatch

func fx(p: CustomStringConvertible) {
  print(p)
}

func gx<T: CustomStringConvertible>(t: T) {
  print(t)
}

let arr = [1,2,3]
let num = 1

fx(arc4random()%2 == 0 ? arr : num)
//gx(arc4random()%2 == 0 ? arr : num) // 错误


//: ## Array Covariance
sizeof(String.self)
sizeof(Any.self)

func anyArguments(args: [Any]) { }
let args = ["1", "2"]
//anyArguments(args) 错误 [String] -> [Any]


class C { }
class D: C { }

let d = D()
let c: C = d
unsafeBitCast(d, UnsafePointer<Void>.self)
unsafeBitCast(c, UnsafePointer<Void>.self)

func fc(cs: [C]) {}
let ds = [D(), D()]
fc(ds)

protocol P {
}

extension C: P {}

sizeofValue(C())
sizeofValue(C() as P)

func gc(ps: [P]) { }
//gc(ds)// 错误

