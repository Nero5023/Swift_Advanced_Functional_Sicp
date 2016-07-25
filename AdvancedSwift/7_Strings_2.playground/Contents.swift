//: Playground - noun: a place where people can play

import UIKit

//: # Inernal Structure of String

let hello = "helloworld111"
let bits = unsafeBitCast(hello, _StringCore.self)
print(bits)

struct StringCoreClone {
  var _baseAddress: COpaquePointer
  var _countAndFlags: UInt
  var _owner: AnyObject?
}

let cloneBits = unsafeBitCast(hello, StringCoreClone.self)

print(cloneBits._baseAddress)
cloneBits._countAndFlags
let output = puts(UnsafePointer(cloneBits._baseAddress))
print("output:\(output)")

let emoji = "Hello, 🌏"
let emojiBits = unsafeBitCast(emoji, StringCoreClone.self)
emojiBits._countAndFlags
print(emojiBits._baseAddress)
emoji._core.count
emoji.characters.count

extension StringCoreClone {
  var count: Int {
    let mask = 0b11 << UInt(sizeof(UInt)*8 - 2)
    // ~ 二进制取反 前两位是tag位，标志是否ascii什么的
    return Int(_countAndFlags & ~mask)
  }
}

emojiBits.count


sizeof(StringCoreClone)
sizeof(String)
let mask = 0b11 << UInt(sizeof(UInt)*8 - 2)

let buf = UnsafeBufferPointer(start: UnsafePointer<UInt16>(emojiBits._baseAddress), count: emojiBits.count)
var gen = buf.generate()
var uft16 = UTF16()
while case let .Result(scalar) = uft16.decode(&gen) {
  print(scalar, terminator: "")
}
print()

var greeting = "hello"
greeting.appendContentsOf("world")
let greetingBits = unsafeBitCast(greeting, StringCoreClone.self)
greetingBits._owner

let ns = "hello" as NSString
let str = ns as String
let (_, _, owner) = unsafeBitCast(str, (UInt, UInt, NSString).self)
print(owner)
owner == ns

//: # Internal Organization of Character
sizeof(Character)

// like this
//enum Char {
//  case Large(Buffer)
//  case Small(Int64)
//}

//: # Code Unit Views

extension String  {
  func words(splitBy: NSCharacterSet = .alphanumericCharacterSet()) -> [String] {
    return self.utf16.split {
      !splitBy.characterIsMember($0)
    }.flatMap(String.init)
  }
}

let s = "Wow! This contains _all_ kinds of things like 123 and \"quotes\"?"
s.words()

extension String.UTF16Index: RandomAccessIndexType {
  
}
//
//let helloworld = "Hello, world!"
//if let idx = helloworld.utf16.search("world".utf16)?.samePositionIn(helloworld) {
//  print
//}


//: # CustomStringConvertible and CustomDegubStringConvertible
struct TestString {
  var name: String
}

extension TestString: CustomStringConvertible {
  var description: String {
    return "\(name)"
  }
}

extension TestString: CustomDebugStringConvertible {
  var debugDescription: String {
    return "debug:\(name)"
  }
}

print(TestString(name: "123"))


struct Queue<Element> {
  private var left: [Element]
  private var right: [Element]
  
  init() {
    left = []
    right = []
  }
  
  mutating func enqueue(element: Element) {
    right.append(element)
  }
  
  mutating func dequeue() -> Element? {
    if left.isEmpty && right.isEmpty {
      return nil
    }
    
    if left.isEmpty {
      left = right.reverse()
      right.removeAll(keepCapacity: true)
    }
    return left.removeLast()
  }
}

extension Queue: CollectionType{
  var startIndex: Int { return 0 }
  var endIndex: Int { return left.count + right.count }
  
  subscript(idx: Int) -> Element {
    if idx > endIndex {
      fatalError("Index out of bounds")
    }
    if idx < left.endIndex {
      return left[left.count - idx.successor()]
    }else {
      return right[idx - left.count]
    }
  }
}

extension Queue: ArrayLiteralConvertible {
  init(arrayLiteral elements: Element...) {
    self.left = elements.reverse()
    self.right = []
  }
}



extension Queue: Streamable {
  func writeTo<Target : OutputStreamType>(inout target: Target) {
    print("[" ,terminator: "", toStream: &target)
    print(self.map{String($0)}.joinWithSeparator(","),terminator: "", toStream: &target)
    print("]" ,terminator: "", toStream: &target)
  }
}



var outs = ""
let q: Queue = [1,2,3]

q.writeTo(&outs)
outs

struct ArrayStream: OutputStreamType {
  var buf: [String] = []
  mutating func write(string: String) {
    buf.append(string)
  }
}

extension NSMutableData: OutputStreamType {
  public func write(string: String) {
    string.nulTerminatedUTF8.dropLast().withUnsafeBufferPointer {
      self.appendBytes($0.baseAddress, length: $0.count)
    }
  }
}

struct SlowStreamer: Streamable, ArrayLiteralConvertible {
  let contents: [String]
  init(arrayLiteral elements: String...) {
    contents = elements
  }
  
  func writeTo<Target : OutputStreamType>(inout target: Target) {
    for x in contents {
      print(x, toStream: &target)
      sleep(1)
    }
  }
}

let slow: SlowStreamer = [
  "You'll see that this gets",
  "wirtten slowly line by line",
  "to the standard output"
]
print(slow)

//struct StdErr: OutputStreamType {
//  mutating func write(string: String) {
//    UnsafePointer<UInt32>(string)
//    fputc(string, stderr)
//  }
//}
//var standarderror = StdErr()
//print("opps!", &standarderror)

//struct ReplacingStream<T: OutputStreamType>: OutputStreamType {
//  var outputStream: T
//  let toReplace: DictionaryLiteral<String, String>
//  init(replacing: DictionaryLiteral<String, String>, ouput: T) {
//    outputStream = ouput
//    toReplace = replacing
//  }
//  
//  mutating func write(string: String) {
//    let toWrite = toReplace.reduce(string) {
//      $0.stringByReplacingOccurrencesOfString($1.0, withString: $1.1)
//    }
//    print(toWrite, &outputStream, appendNewline: false)
//  }
//}

//var replacer = ReplacingStream(
//  replacing: ["in the cloud": "on someone else's computer"],
//  output: standarderror)
//let source = "More and more people are finding it convenient " +
//"to store their data in the cloud."
//print(source, &replacer)

let dics = DictionaryLiteral(dictionaryLiteral: ("1", "2"), ("1", "2"))
print(dics)