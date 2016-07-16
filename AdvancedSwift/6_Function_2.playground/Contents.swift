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
