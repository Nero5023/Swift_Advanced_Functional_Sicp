//: Playground - noun: a place where people can play

import UIKit

import Foundation

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

public struct List<Element>: CollectionType {
  public typealias Index = ListIndex<Element>
  
  public var startIndex: Index
  public var endIndex: Index
  
  public subscript(idx: Index) -> Element {
    switch idx.node {
    case .End:
      fatalError("Subscript out of range")
    case let .Node(x, _):
      return x
    }
  }
}

extension List: ArrayLiteralConvertible {
  public init(arrayLiteral elements: Element...) {
    startIndex = ListIndex(node: elements.reverse().reduce(.End){
      $0.cons($1)
      }, tag: elements.count)
    endIndex = ListIndex(node: .End, tag: 0)
  }
}

let l: List = ["one", "two", "three"]
l.first
l.indexOf("one")?.tag

extension List {
  // Mark sure cout is O(1)
  public var count: Int {
    return startIndex.tag - endIndex.tag
  }
}

public func == <T: Equatable>(lhs: List<T>, rhs: List<T>) -> Bool {
  return lhs.elementsEqual(rhs)
}

sizeofValue(l)

l[l.startIndex.successor()..<l.endIndex]


//struct Slice<Base: CollectionType>: CollectionType {
//  let collection: Base
//  let bounds: Range<Base.Index>
//  
//  var startIndex: Base.Index { return bounds.startIndex }
//  var endIndex: Base.Index { return bounds.endIndex }
//  
//  subscript(idx: Base.Index) -> Base.Generator.Element {
//    return collection[idx]
//  }
//  
//  typealias SubSequence = Slice<Base>
//  subscript(bounds: Range<Base.Index>) -> Slice<Base> {
//    return Slice(collection: collection, bounds: bounds)
//  }
//}

sizeofValue(l)
sizeofValue(l.dropLast())
l.suffix(2)
var array = [1,2,3,45,65,6,3]
var sub = array.suffix(2)

for s in l.indices {
  print(s.tag)
}

class GPrefixGenerator<Base: CollectionType> {
  let base: Base
  var offset: Base.Index
  
  init(_ base: Base) {
    self.base = base
    self.offset = base.startIndex
  }
  
  func next() -> Base.SubSequence? {
    guard offset != base.endIndex else { return nil }
    offset = offset.successor()
    return base.prefixUpTo(offset)
  }
}


extension List {
  public func reverse() -> List<Element> {
    let reversedNodes: ListNode<Element> = self.reduce(.End) { $0.cons($1) }
    return List(startIndex: ListIndex(node: reversedNodes, tag: self.count), endIndex: ListIndex(node: .End, tag: 0))
  }
}

l.reverse()

let reversedArray: [String] = l.reverse()
l.reverse().elementsEqual(l.reverse() as [String])

l.reverse() as Any is List<String>

//BidirectionalIndexType 双向

//struct ReverseIndex<Base: BidirectionalIndexType>: BidirectionalIndexType {
//  let idx: Base
//  
//  func successor() -> ReverseIndex<Base> {
//    return ReverseIndex(idx: idx.predecessor())
//  }
//  
//  func predecessor() -> ReverseIndex<Base> {
//    return ReverseIndex(idx: idx.successor())
//  }
//}
//
//func ==<T>(lhs: ReverseIndex<T>, rhs: ReverseIndex<T>) -> Bool {
//  return lhs.idx == rhs.idx
//}
//
//struct ReverseCollection<Base: CollectionType where Base.Index: BidirectionalIndexType>: CollectionType {
//  let base: Base
//  
//  var startIndex: ReverseIndex<Base.Index> {
//    return ReverseIndex(idx: base.endIndex)
//  }
//  
//  var endIndex: ReverseIndex<Base.Index> {
//    return ReverseIndex(idx: base.startIndex)
//  }
//  
//  subscript(idx: ReverseIndex<Base.Index>) -> Base.Generator.Element {
//    return base[idx.idx.predecessor()]
//  }
//}
//RandomAccessIndexType
