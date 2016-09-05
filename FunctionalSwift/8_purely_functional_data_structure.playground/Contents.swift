//: Playground - noun: a place where people can play

import UIKit

//: ## Binary Search Tree

extension SequenceType {
  func all(predicate: Generator.Element->Bool) -> Bool {
    for x in self where !predicate(x) {
      return false
    }
    return true
  }
}


indirect enum BinarySearchTree<Element: Comparable> {
  case Leaf
  case Node(BinarySearchTree<Element>, Element, BinarySearchTree<Element>)
}

extension BinarySearchTree {
  init() {
    self = .Leaf
  }
  
  init(_ value: Element) {
    self = .Node(.Leaf, value, .Leaf)
  }
}

extension BinarySearchTree {
  var count: Int {
    switch self {
    case .Leaf:
      return 0
    case let .Node(left, _, right):
      return left.count + 1 + right.count
    }
  }
  
  var elements: [Element] {
    switch self {
    case .Leaf:
      return []
    case let .Node(left, x, right):
      return left.elements + [x] + right.elements
    }
  }
  
  var isEmpty: Bool {
    if case .Leaf = self {
      return true
    }
    return false
  }
  
  var isBST: Bool {
    switch self {
    case .Leaf:
      return true
    case let .Node(left, x, right):
      return left.elements.all{ y in x > y } &&
        right.elements.all{ y in x < y } &&
        left.isBST &&
        right.isBST
    }
  }
  
  func contains(x: Element) -> Bool {
    switch self {
    case .Leaf:
      return false
    case let .Node(_, y, _) where y == x:
      return true
    case  let .Node(left, y, _) where x < y:
      return left.contains(x)
    case let .Node(_, y, right) where x > y:
      return right.contains(x)
    default:
      fatalError("impossible case")
    }
  }
  
  mutating func insert(x: Element) {
    switch self {
    case .Leaf:
      self = BinarySearchTree(x)
    case .Node(var letf, let y, var right):
      if x < y { letf.insert(x) }
      if x > y { right.insert(x) }
      self = .Node(letf, y, right)
    }
  }
}

var tree = BinarySearchTree(10)
tree.insert(1)
tree.insert(11)
tree.insert(2)
tree.insert(3)
tree.insert(20)

//: ## Autocompletion Using Tries

func autocomplete(history: [String], textEntered: String) -> [String] {
  return history.filter{ $0.hasPrefix(textEntered) }
}


//struct Tire<Element: Hashable> {
//  let isElement: Bool
//  let children: [Element: Tire<Element>]
//}

struct Trie<Element: Hashable> {
    let isElement: Bool
    let children: [Element: Trie<Element>]
}

extension Trie {
    init() {
        isElement = false
        children = [:]
    }
}

extension Trie {
    var elements: [[Element]] {
        // 如果是 isElement == ture 返回 [] // ?
        var result: [[Element]] = isElement ? [[]] : []
        for (key, value) in children {
            result += value.elements.map { [key] + $0 }
        }
        return result
    }
}

extension Array {
    var decompose: (Element, [Element])? {
        return isEmpty ? nil : (self[startIndex], Array(self.dropFirst()))
    }
}

func sum(xs: [Int]) -> Int {
    guard let (head, tail) = xs.decompose else { return 0 }
    return head + sum(tail)
}


extension Trie {
    func lookup(key: [Element]) -> Bool {
        guard let (head, tail) = key.decompose else { return isElement }
        guard let subtrie = children[head] else { return false }
        return subtrie.lookup(tail)
    }
    
    func withPrefix(prefix: [Element]) -> Trie<Element>? {
        guard let (head, tail) = prefix.decompose else { return self }
        guard let remainder = children[head] else { return nil }
        return remainder.withPrefix(tail)
    }
    
    func autocomplete(key: [Element]) -> [[Element]] {
        return withPrefix(key)?.elements ?? []
    }
    
    init(_ key: [Element]) {
        if let (head, tail) = key.decompose {
            let children = [head: Trie(tail)]
            self = Trie(isElement: false, children: children)
        }else {
            self = Trie(isElement: true, children: [:])
        }
    }
    
    func insert(key: [Element]) -> Trie<Element> {
        guard let (head, tail) = key.decompose else {
            return Trie(isElement: true, children: self.children)
        }
        var newChildren = children
        if let nextTrie = children[head] {
            newChildren[head] = nextTrie.insert(tail)
        }else {
            newChildren[head] = Trie(tail)
        }
        return Trie(isElement: isElement, children: newChildren)
    }
    
//    func insert<Seq: CollectionType where Seq.Generator.Element == Element>(key: Seq) -> Trie<Element> {
//        guard let (head, tail) = key.decompose else {
//            return Trie(isElement: true, children: self.children)
//        }
//        var newChildren = children
//        if let nextTrie = children[head] {
//            newChildren[head] = nextTrie.insert(tail)
//        }else {
//            newChildren[head] = Trie(tail)
//        }
//        return Trie(isElement: isElement, children: newChildren)
//    }
    
}

func buildStringTrie(words: [String]) -> Trie<Character> {
    let emptyTrie = Trie<Character>()
    return words.reduce(emptyTrie) { trie, word in
        trie.insert(Array(word.characters))
    }
}

func autocompleteString(knowWords: Trie<Character>, word: String) -> [String] {
    let chars = Array(word.characters)
    let completed = knowWords.autocomplete(chars)
    return completed.map { chars in
        word + String(chars)
    }
}

let contents = ["cat", "car", "cart", "dog"]
let trieOfWords = buildStringTrie(contents)
autocompleteString(trieOfWords, word: "car")
print(trieOfWords.elements)