//: Playground - noun: a place where people can play

import UIKit

protocol ObserverType {
  associatedtype Event
  func receive(event: Event)
}

struct StringEventReceiver: ObserverType {
  func receive(event: String) {
    print("Received:\(event)")
  }
}

//protocol Observable {
//  mutating func register<O: ObserverType>(observer: O)
//}


protocol Observable {
  associatedtype Event
  mutating func register<O: ObserverType where O.Event == Event>(observer: O)
}


//: # Erasing Types Using Closures

struct StringEventGenerator: Observable {
  typealias Event = String
  
  var observers: [String->()] = []
  
  mutating func register<O : ObserverType where O.Event == String>(observer: O) {
//    observers.append(observer.receive) //两者等价
    observers.append{ observer.receive($0) }
  }
  
  func fireEvent(event: String) {
    for observer in observers {
      observer(event)
    }
  }
  
}

var gen1 = StringEventGenerator()
let rec1 = StringEventReceiver()
gen1.register(rec1)
gen1.fireEvent("hi")

//: # Replacing Protocol Callbacks with Functions


protocol Observable0 {
  associatedtype Event
  mutating func register(observer: Event->())
}

struct StringEventGenerator0: Observable0 {
  var observers: [String -> ()] = []
  mutating func register(observer: String->()) {
    observers.append(observer)
  }
  
  func fireEvent(event: String) {
    for observer in observers {
      observer(event)
    }
  }
}



struct StringEventReceiver0 {
  func receive(event: String) {
    print("Received:\(event)")
  }
}

var g0 = StringEventGenerator0()
var r0 = StringEventReceiver0()
let callback = StringEventReceiver0.receive(r0)
//或者 let callback = r0.receive
g0.register(callback)

g0.register{ print("Closure received\($0)") }

//: # Giving Value Types Reference Semantics Using Closures

struct StringStoringReceiver {
  var str = ""
  mutating func receive(event: String) {
    str += str.isEmpty ? event : ",\(event)"
  }
}

var stringR = StringStoringReceiver()

//g0.register(stringR.receive) // not allowed

// 闭包捕获值了
g0.register{ stringR.receive($0) }

g0.fireEvent("hi!")
g0.fireEvent("one")
g0.fireEvent("two")
print(stringR)