//: Playground - noun: a place where people can play

import UIKit

//: Computed Properties and Subscripts

struct File {
  let path: String
  
  func computeSize() -> Int? {
    let fm = NSFileManager.defaultManager()
    guard let dict = try?fm.attributesOfItemAtPath(self.path),
      let size = dict["NSFileSize"] as? Int
      else { return nil }
    return size
  }
  
  private var cachedSize: Int? = nil
  
  mutating func cachedComputeSize() -> Int? {
    guard cachedSize == nil else { return cachedSize! }
    let fm = NSFileManager.defaultManager()
    guard let dict = try?fm.attributesOfItemAtPath(self.path),
      let size = dict["NSFileSize"] as? Int
      else { return nil }
    cachedSize = size
    return size
  }
  
  //store property
  lazy var size: Int? = {
    let fm = NSFileManager.defaultManager()
    guard let dict = try?fm.attributesOfItemAtPath(self.path),
      let size = dict["NSFileSize"] as? Int
      else { return nil }
    return size
  }()
  
  //computer property
  var size1: Int? {
    let fm = NSFileManager.defaultManager()
    guard let dict = try?fm.attributesOfItemAtPath(self.path),
      let size = dict["NSFileSize"] as? Int
      else { return nil }
    print(111)
    return size
  }
  
  
  
  init(_ path: String) {
    self.path = path
    
  }
  
  // willset 是 store property 有的
  var test: String? {
    willSet {
      
    }
  }
}


var file = File("/Users/Nero/Desktop")
print(file.cachedComputeSize())
file.size //存储属性 store property
file.size

file.size1//计算属性 computer property

extension File {
//  computer property可以在 extension 中 而 store property 不可以
  var data: NSData? {
    get {
      return NSData(contentsOfFile: path)
    }
    set {
      let theData = newValue ?? NSData()
      theData.writeToFile(path, atomically: true)
    }
  }
  

}
var file1 = File("/Users/Nero/Desktop/test.txt")
file1.data = NSData(base64EncodedString: "Helloworld", options: NSDataBase64DecodingOptions(rawValue: 1))
file1.size1

//: # Overloading Subscriptis with different arguments

struct RangeStart<I: ForwardIndexType> { let start: I }

struct RangeEnd<I: ForwardIndexType> { let end: I }


postfix operator ..< {}
postfix func ..<<I: ForwardIndexType>(lhs: I) -> RangeStart<I> {
  return RangeStart(start: lhs)
}

prefix operator ..< {}
prefix func ..<<I: ForwardIndexType>(rhs: I) -> RangeEnd<I> {
  return RangeEnd(end: rhs)
}

extension CollectionType {
  subscript(r: RangeStart<Self.Index>) -> SubSequence {
    return self[r.start..<self.endIndex]
  }
  
  subscript(r: RangeEnd<Self.Index>) -> SubSequence {
    return self[self.startIndex..<r.end]
  }
}
let fibs = [0, 1, 1, 2, 3, 5]
fibs[2..<]


extension CollectionType where Generator.Element: Equatable, SubSequence.Generator.Element == Generator.Element {
  func search<S: SequenceType where S.Generator.Element == Generator.Element>(pat: S) -> Index? {
    return self.indices.indexOf {
      self[$0..<].startsWith(pat)
    }
  }
}

let greeting = "Hello, World!"
if let idx = greeting.characters.search(",".characters) {
  print(String(greeting.characters[..<idx]))
}

//: # Advance Subscripts
extension Dictionary {
  subscript(key: Key, or defaultValue:Value) -> Value {
    get {
      return self[key] ?? defaultValue
    }
    set(newValue) {
      self[key] = newValue
    }
  }
}

//一个sequence中element出现的次率
extension SequenceType where Generator.Element: Hashable {
  func frequencies() -> [Generator.Element: Int] {
    var result: [Generator.Element: Int] = [:]
    for x in self {
      result[x, or: 0] += 1
    }
    return result
  }
}