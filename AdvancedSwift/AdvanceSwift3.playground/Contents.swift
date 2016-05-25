//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
var array = [1,3,3,45]
//array.split(3)

let suits = ["♠", "♥", "♣", "♦"]
let randks = ["J","Q","K","A"]
let allCombinations = suits.flatMap { suit in
  return randks.map { rank in
    return (suit, rank)
  }
}
array[1..<array.endIndex]

// MARK: Dictionaries and Sets

protocol Setting {
  func settingsView() -> UIView
}

//let defaultSettings: [String: Setting] = [
//  "Arirplane Mode": true,
//  "Name": "My iPhone",
//]

var dictionary = [
    "Arirplane Mode": "true",
    "Name": "My iPhone",
]
dictionary.updateValue("abc", forKey: "Name") // return the forKey's origin value
dictionary["2"]
//print(Repeat(count: -1,repeatedValue: 2).endIndex)

//MARK: Some Useful Dictionary Extensions

extension Dictionary {
  mutating func merge<S: SequenceType where S.Generator.Element == (Key, Value)>(other: S) {
    for (k, v) in other {
      self[k] = v
    }
  }
  
  init<S: SequenceType where S.Generator.Element == (Key, Value)>(_ sequce: S) {
    self = [:]
    self.merge(sequce)
  }
  
  func mapValues<NewValue>(transform: Value -> NewValue) -> [Key: NewValue] {
    return Dictionary<Key, NewValue>(self.map { (key, value) in
      return (key, transform(value))
    })
  }
}

let defulatAlarms = (1..<5).map {("Alarm \($0)", false) }
let alarmsDictionary = Dictionary(defulatAlarms)

extension SequenceType where Generator.Element: Hashable {
  func unique() -> [Generator.Element] {
    var seen: Set<Generator.Element> = []
    return self.filter {
      if seen.contains($0) {
        return false
      }else {
        seen.insert($0)
        return true
      }
    }
  }
}


// MARK: Collection Protocols

//public protocol GeneratorType {
//  associatedtype Element
//  @warn_unused_result
//  public mutating func next() -> Self.Element?
//}

class ConstantGenerator: GeneratorType {
  typealias Element = Int
  func next() -> Element? {
    return 1
  }
}

class FibsGenerator: GeneratorType {
  var state = (0, 1)
  func next() -> Int? {
    let upcompingNumber = state.0
    state = (state.1, state.0 + state.1)
    return upcompingNumber
  }
}

class PrefixGenerator: GeneratorType {
  let string: String
  var offset: String.Index
  
  init(string: String) {
    self.string = string
    offset = string.startIndex
  }
  
  func next() -> String? {
    guard offset < string.endIndex else { return nil }
    offset = offset.successor()
    return string[string.startIndex..<offset]
  }
}

let seq = 0.stride(to: 9, by: 1)
var g1 = seq.generate()
g1.next()
g1.next()

var g2 = g1
g1.next()
g1.next()
g2.next()
g2.next()

var g3 = AnyGenerator(g1)
g3.next()
g1.next()
g3.next()
g3.next()
g1.next()
g3.next()

//protocol SequenceType {
//  associatedtype Generator: GeneratorType
//  func generate() -> Generator
//}

struct PrefixSequence: SequenceType {
  let string: String
  
  func generate() -> PrefixGenerator {
    return PrefixGenerator(string: string)
  }
}

for prefix in PrefixSequence(string: "Hello") {
  print(prefix)
}

//var generator = PrefixSequence(string: "Hello").generate()
//while let prefix = generator.next() {
//  print(prefix)
//}

// Funcftion-Based Generators and Sequences
func fibGenerator() -> AnyGenerator<Int> {
  var state = (0, 1)
  return AnyGenerator {
    let result = state.0
    state = (state.1, state.0+state.1)
    return result
  }
}

let fibSequence = AnySequence(fibGenerator)

class FibGenerator: GeneratorType {
  var state = (0, 1)
  func next() -> Int? {
    let result = state.0
    state = (state.1, state.0+state.1)
    return result
  }
}

struct FibSequence: SequenceType {
  func generate() -> FibGenerator {
    return FibGenerator()
  }
}

//MARK: Collections

protocol QueueType {
  associatedtype Element
  mutating func enqueue(newElement: Element)
  mutating func dequeue() -> Element?
}


struct Queue<Element>: QueueType {
  private var left: [Element]
  private var right: [Element]
  
  init() {
    left = []
    right = []
  }
  
  mutating func enqueue(newElement: Element) {
    right.append(newElement)
  }
  
  mutating func dequeue() -> Element? {
    guard !(left.isEmpty && right.isEmpty) else { return nil }
    
    if left.isEmpty {
      left = right.reverse()
      right.removeAll(keepCapacity: true)
    }
    return left.removeLast()
    
  }
}

extension Queue: CollectionType {
  var startIndex: Int { return 0 }
  var endIndex: Int { return left.count + right.count }
  
  subscript(idx: Int) -> Element {
    precondition((0..<endIndex).contains(idx), "Index out of bounds")
    if idx < left.endIndex {
      return left[left.count - idx.successor()]
    }else {
      return right[idx - left.count]
    }
    
  }
}

var q = Queue<String>()
for x in ["1", "2", "foo", "3"] {
  q.enqueue(x)
}

var generator = q.generate()
generator.next()
q.joinWithSeparator(",")
q.flatMap { Int($0) }

extension Queue: ArrayLiteralConvertible {
  init(arrayLiteral elements: Element...) {
    self.left = elements.reverse()
    self.right = []
  }
}

extension Queue: RangeReplaceableCollectionType {
  mutating func reserveCapacity(n: Int) {
    return
  }
  
  mutating func replaceRange<C : CollectionType where C.Generator.Element == Element>(subRange: Range<Int>, with newElements: C) {
    right = left.reverse() + right
    left.removeAll()
    right.replaceRange(subRange, with: newElements)
  }
  
  // empty initializer already implement in the queue
}


// MARK: Indices

enum List<Element> {
  case End
  indirect case Node(Element, next: List<Element>)
}

extension List {
  func cons(x: Element) -> List {
    return .Node(x, next: self)
  }
}

let l = List<Int>.End.cons(1).cons(2)


protocol StackType {
  associatedtype Element
  
  mutating func push(x: Element)
  
  mutating func pop() -> Element?
}

extension Array: StackType {
  mutating func push(x: Element) {
    append(x)
  }
  
  mutating func pop() -> Element? {
    return popLast()
  }
}

extension List: StackType {
  mutating func push(x: Element) {
    self = self.cons(x)
  }
  
  mutating func pop() -> Element? {
    switch self {
    case .End:
      return nil
    case let .Node(x, next: xs):
      self = xs
      return x
    }
  }
}

var stack = List<Int>.End.cons(1).cons(2).cons(3)
var a = stack
var b = stack

a.pop()
a.pop()
a.pop()

stack.pop()
stack.push(4)

b.pop()
b.pop()
b.pop()

stack.pop()
stack.pop()
stack.pop()

extension List: SequenceType {
  func generate() -> AnyGenerator<Element> {
    var current = self
    return AnyGenerator {
      current.pop()
    }
    
  }
}

extension List: ArrayLiteralConvertible {
  init(arrayLiteral elements: Element...) {
    self = elements.reverse().reduce(.End) {
      $0.cons($1)
    }
  }
}

let list: List = ["1", "2", "3"]
for x in list {
  print("\(x)", terminator: "")
}

private enum ListNode<Element> {
  case End
  indirect case Node(Element, next: ListNode<Element>)
  
  func cons(x: Element) -> ListNode<Element> {
    return .Node(x, next: self)
  }
}

public struct ListIndex<Element> {
  private let node: ListNode<Element>
  private let tag: Int
}

extension ListIndex: ForwardIndexType {
  public func successor() -> ListIndex<Element> {
    switch node {
    case let .Node(_, next: next):
      return ListIndex(node: next, tag: tag.predecessor())
    case .End:
      fatalError("cannot increment endIndex")
    }
  }
}

public func ==<T>(lhs: ListIndex<T>, rhs: ListIndex<T>) -> Bool {
  return lhs.tag == rhs.tag 
}

