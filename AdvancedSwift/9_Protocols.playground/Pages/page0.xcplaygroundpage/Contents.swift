//: Playground - noun: a place where people can play

import UIKit

struct DateRange {
  var startDate: NSDate
  var endDate: NSDate
}

extension DateRange {
  init(startDate: NSDate = NSDate(), durationInDays days: Int = 1) {
    self.startDate = startDate
    self.endDate = startDate
  }
  
  func contaions(date: NSDate) -> Bool {
    return true
  }
}

struct Event {
  let title: String
  let date: NSDate
}

protocol CalendarViewDelegate {
  
}

class MyCalendarView: UIView {
  var displayRange: DateRange = DateRange()
  var delegate: CalendarViewDelegate?
  var events: [Event] = []
  
  func setupViews() {
    let displayedEvents = events.filter {
        displayRange.contaions($0.date)
    }
    for event in displayedEvents {
      addEventView(event)
    }
  }
  
  func addEventView(event: Event) {
    
  }
  
}

//: ## Overriding Protocol Methods

protocol Shareable {
  var socialMediaDescription: String { get }
}

extension Shareable {
  func share() {
    print("Sharing:\(self.socialMediaDescription)")
  }
  
  func linesAndShare() {
    print("----------")
    share()
    print("----------")
  }
}

extension String: Shareable {
  var socialMediaDescription: String { return self }
  
  func share() {
    print("Special String Sharing:\(self.socialMediaDescription)")
  }
}

"hello".share()

let hello: Shareable = "hello"
hello.share()// Print: "Sharing:hello" 

"hello".linesAndShare()
// print: ----------
//Sharing:hello
//----------

// 这里因为在protocol中没有声明share这个方法，在extension中实现了，所以这里是static dispatch
// 如果在protocol中声明那么就是dynamic dispatch

//: # adding associated type


protocol CalendarView {
  associatedtype EventType
  
  var displayRange: DateRange { get set }
  var delegate: CalendarViewDelegate? { get set }
  var events: [EventType] { get set }
}

protocol HasDate {
  var date: NSDate { get }
}

extension CalendarView where EventType: HasDate {
  var eventsInRange: [EventType] {
    return events.filter{ displayRange.contaions($0.date) }
  }
}

struct TextCalendarView<E: HasDate>: CalendarView {
  var displayRange: DateRange
  var delegate: CalendarViewDelegate?
  var events: [E]
  
  func display() {
    for event in eventsInRange {
      let formatter = NSDateFormatter()
      formatter.dateStyle = .ShortStyle
      formatter.timeStyle = .ShortStyle
      print("\(formatter.stringFromDate(event.date)):\(event)")
    }
  }
}

//: [Next](@next)
