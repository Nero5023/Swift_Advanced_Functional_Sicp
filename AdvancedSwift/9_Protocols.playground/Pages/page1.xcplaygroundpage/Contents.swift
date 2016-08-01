//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: # Protocols with Self Requirements

//struct Event {
//  let title: String
//  let date: NSDate
//}

protocol EventLike {
  var date: NSDate { get }
  var title: String { get }
  func overlapsWith(other: Self) -> Bool
}


//extension Event: EventLike {
//
//}
//
//let sampleEvent: EventLike = Event(title: "My event", date: NSDate())


struct Event {
  let title: String
  let date: NSDate
  let durationInSeconds: NSTimeInterval
}

extension Event: EventLike {
  func overlapsWith(other: Event) -> Bool {
    return date.timeIntervalSinceDate(other.date) < durationInSeconds || other.date.timeIntervalSinceDate(date) < other.durationInSeconds
  }
}

//let test: EventLike = Event(title: "chris", date: NSDate(), durationInSeconds: 100) // 错误

//let array: [EventLike] = [] // 错误

struct EventStorage<E: EventLike> {
  let events: [E]
}

extension EventStorage {
  func containsOverlappingEvent(event: E) -> Bool {
    return !events.lazy.filter(event.overlapsWith).isEmpty
  }
}

//: ## Asoociated Types

protocol StoringType {
  associatedtype Stored
  init(_ value: Stored)
  func getStored() -> Stored
}

struct IntStorer: StoringType {
  private let stored: Int
  init(_ value: Int) {
    stored = value
  }
  func getStored() -> Int {
    return stored
  }
}

struct StringStorer: StoringType {
  private let stored: String
  init(_ value: String) {
    stored = value
  }
  func getStored() -> String {
    return stored
  }
}

func printSoredValue<S: StoringType>(storer: S) {
  let x = storer.getStored()
  print(x)
}

//: [Next](@next)



