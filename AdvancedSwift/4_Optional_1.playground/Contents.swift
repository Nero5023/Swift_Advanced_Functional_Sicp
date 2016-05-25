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
  XCPCaptureValue("Hello world!", value: x)
}


