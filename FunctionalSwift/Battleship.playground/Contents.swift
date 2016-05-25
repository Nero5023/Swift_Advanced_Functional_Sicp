//: Playground - noun: a place where people can play

import UIKit

typealias Distance = Double

struct Position {
  var x: Double
  var y: Double
}

extension Position {
  func inRange(range: Distance) -> Bool {
    return sqrt(x*x + y*y) <= range
  }
  
  func minus(p: Position) -> Position {
    return Position(x: x-p.x, y: y-p.y)
  }
  var length: Double {
    return sqrt(x*x + y*y)
  }
}

struct Ship {
  var position: Position
  var firingRange: Distance
  var unsafeRange: Distance
}

//extension Ship {
//  func canEngageShip(target: Ship) -> Bool {
//    let dx = target.position.x - position.x
//    let dy = target.position.y - position.y
//    let targetDistance = sqrt(dx*dx + dy*dy)
//    return targetDistance <= firingRange
//  }
//  
//  func canSafelyEngageShip(target: Ship) -> Bool {
//    let dx = target.position.x - position.x
//    let dy = target.position.y - position.y
//    let targetDistance = sqrt(dx*dx + dy*dy)
//    return targetDistance <= firingRange && targetDistance > unsafeRange
//  }
//  
//  func canSafelyEngageShip1(target: Ship, friendly: Ship) -> Bool {
////    let dx = target.position.x - position.x
////    let dy = target.position.y - position.y
////    let targetDistance = sqrt(dx*dx + dy*dy)
////    let friendlyDx = friendly.position.x - target.position.x
////    let friendlyDy = friendly.position.y - target.position.y
////    let friendlyDistance = sqrt(friendlyDx*friendlyDx + friendlyDy*friendlyDy)
//    
//    let targetDistance = target.position.minus(position).length
//    let friendlyDistance = friendly.position.minus(target.position).length
//    return targetDistance <= firingRange && targetDistance > unsafeRange && friendlyDistance > friendly.unsafeRange
//  }
//}


typealias Region = Position -> Bool


func circle(radius: Distance) -> Region {
  return { point in point.length <= radius }
}


func circle2(radius: Distance, center: Position) -> Region {
  return { point in point.minus(center).length <= radius }
}

func shift(region: Region, offset: Position) -> Region {
  return { point in region(point.minus(offset)) }
}

func invert(region: Region) -> Region {
  return { point in !region(point) }
}

func intersection(region1: Region, _ region2: Region) -> Region {
  return { point in region1(point) && region2(point) }
}

func union(region1: Region, _ region2: Region) -> Region {
  return { point in region1(point) || region2(point) }
}

func difference(region: Region, minus: Region) -> Region {
  return intersection(region, invert(minus))
}

extension Ship {
  func canSafelyEngageShip(target: Ship, friendly: Ship) -> Bool {
    let rangeRegion = difference(circle(firingRange), minus: circle(unsafeRange))
    let firingRegion = shift(rangeRegion, offset: position)
    let friendlyRegion = shift(circle(unsafeRange), offset: friendly.position)
    let resultRegion = difference(firingRegion, minus: friendlyRegion)
    return resultRegion(target.position)
  }
}
