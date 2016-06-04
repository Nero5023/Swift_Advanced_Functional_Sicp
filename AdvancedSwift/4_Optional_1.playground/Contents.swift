//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

//XCPSetExecutionShouldContinueIndefinitely(true)

var str = "Hello, playground"

//enum Optional<T> {
//  case None
//  case Some(T)
//}
//
//
//
//extension CollectionType where Generator.Element: Equatable {
//  func indexOf(element: Generator.Element) -> Optional<Index> {
//    for idx in self.indices where self[idx] == element {
//      return .Some(idx)
//    }
//    return .None
//  }
//}

var array = ["one", "two", "three"]

switch array.indexOf("four") {
case let idx?:
    array.removeAtIndex(idx)
case nil:
    break
}

//let urlString = "http://design.ubuntu.com/wp-content/uploads/ubuntu-logo32.png"
//if let url = NSURL(string: urlString),
//      data = NSData(contentsOfURL: url),
//  image = UIImage(data: data) {
//  let view = UIImageView(image: image)
//  XCPlaygroundPage.currentPage.liveView = view
//}

for x in 1..<100 {
    x
    //  XCPCaptureValue("Hello world!", value: x)
}

let stringScanner = NSScanner(string: "myUserName123")
var username: NSString?
let alphas = NSCharacterSet.alphanumericCharacterSet()

if stringScanner.scanCharactersFromSet(alphas, intoString: &username), let name = username {
    print(name)
}

let array0 = [1,2,3]
var generator = array.generate()
while let i = generator.next() {
    print(i)
}

for i in 0..<10 where i%2 == 0 {
    print(i)
}

var a: [()->Int] = []
for i in 1...3 {
    a.append{ i }
}

for f in a {
    print("\(f())")
}

let stringNumbers = ["1", "2", "3", "foo"]
let maybeInts = stringNumbers.map{ Int($0) }
//var maybeIntsGenerator = maybeInts.generate()
//maybeIntsGenerator.next()

for case let i? in maybeInts {
    //  i will be Int, not Int?
    //  print 1,2 and 3
}

for case let .Some(i) in maybeInts {
    //  same with up
}

for case nil in maybeInts {
    // will run once for each nil
}

let j = 5
if case 0..<10 = j {
    print("\(j) within range")
}

struct Substring {
    let s: String
    init(_ s: String) {
        self.s = s
    }
}

func ~=(pattern: Substring, value: String) -> Bool {
    return value.rangeOfString(pattern.s) != nil
}

let s = "foohelo"
if case Substring("foo") = s {
    print("has substring \"foo\"")
}

if var i = Int("2") {
    i+=1
    print(i)
}

let js = Int("1")?.successor().successor()
print(js)

extension Int {
    func halt() -> Int? {
        guard self > 1 else { return nil }
        return self/2
    }
}

print(20.halt()?.halt()?.halt())

let dicOfArrays = ["nine": [0,1,2,3,4,5,6,7]]
let sevenOfNine = dicOfArrays["nine"]?[7]

let dicOfFuncs: [String: (Int, Int)->Int] = [
    "add":(+),
    "substract":(-)
]
print(dicOfFuncs["add"]?(1,1))

let firstElement = array.first ?? "nil"

extension Array {
    subscript(safe idx: Int) -> Element? {
        return idx < endIndex ? self[idx] : nil
    }
}

let safeElement = array[safe: 5] ?? "one"

do {
    let i: Int? = nil
    let j: Int? = nil
    let k: Int? = 42
    let n = i ?? j ?? k ?? 0
    
    let s1: String?? = nil
    print((s1 ?? "inner") ?? "outer")
    let s2: String?? = .Some(nil)
    print((s2 ?? "inner") ?? "outer")
}

func filterNil<S: SequenceType, T where S.Generator.Element == T?>(source: S) -> [T] {
  return source.lazy.filter{ $0 != nil }.map{ $0! }
}

let source = ["1", "foo", "2", "3", "4", "5", "5"]
source.flatMap{
  Int($0)
}

let arraya: [Int?] = [1,2,3,4,nil]
let arrayb: [Int?] = [1,2,3,4,nil]
//arraya == arrayb

func ~=<I: IntervalType>(pattern: I, value: I.Bound?) -> Bool {
  return value.map{ pattern.contains($0) } ?? false
}

func ~=<T: Equatable>(pattern: T, value: T?) -> Bool {
  return pattern == value
}

for i in ["2", "foo", "42", "100"] {
  switch Int(i) {
  case 42:
    print("The meaning of life")
  case 0..<10:
    print("A signle digit")
  case nil:
    print("Not a number")
  default:
    print("A mystery number")
  }
}

let ages = [
  "Tim": 53, "Angela": 54, "Craig": 44,
  "Jony": 47, "Chris": 37, "Michael":34
]

let people = ages.filter{
  (_, age) in age < 50
  }.map {
    (name, _) in name
}.sort()


infix operator !! {}

func !!<T>(wrapped: T?, @autoclosure failureText:()->String) -> T {
  if let x = wrapped { return x }
  fatalError(failureText())
}

infix operator !? {}

func !?<T: IntegerLiteralConvertible>(wrapped:T?, @autoclosure failureText:()->String) -> T {
  assert(wrapped != nil, failureText())
  return wrapped ?? 0
}

func !?<T: ArrayLiteralConvertible>(wrapped:T?, @autoclosure failureText:()->String) -> T {
  assert(wrapped != nil, failureText())
  return wrapped ?? []
}

func !?<T: StringLiteralConvertible>(wrapped:T?, @autoclosure failureText:()->String) -> T {
  assert(wrapped != nil, failureText())
  return wrapped ?? ""
}

func !?<T>(wrapped:T?, @autoclosure nilDefault:()->(value:T, text:String)) -> T {
//  assert(wrapped != nil, failureText())
//  return wrapped ?? ""
  assert(wrapped != nil, nilDefault().text)
  return wrapped ?? nilDefault().value
}

func !?(wrapped:()?, @autoclosure failureText:()->String) {
  assert(wrapped != nil, failureText)
}

