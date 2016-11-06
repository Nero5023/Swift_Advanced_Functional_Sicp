//: Playground - noun: a place where people can play

import Foundation
public enum List<T: CustomStringConvertible>: CustomStringConvertible{
    typealias Element = T
    case value(T)
    indirect case list(List<T>, List<T>)
    case null
    
    init(_ car: T?, _ cdr: T?) {
        if let car = car, let cdr = cdr {
            self = .list(.value(car), .value(cdr))
            return
        }
        if let car = car {
            self = .list(.value(car), .null)
            return
        }
        if let cdr = cdr {
            self = .list(.null, .value(cdr))
            return
        }
        self = .list(.null, .null)
    }
    
    init(_ car: List<T>, _ cdr: List<T>) {
        self = .list(car, cdr)
    }
    
    init(_ car: T?, _ cdr: List<T>) {
        if let car = car {
            self = .list(.value(car), cdr)
        }else {
            self = .list(.null, cdr)
        }
    }
    
    init(_ car: List<T>, _ cdr: T?) {
        if let cdr = cdr {
            self = .list(car, .value(cdr))
        }else {
            self = .list(car, .null)
        }
    }
    
    public var description: String {
        switch self {
        case .value(let x):
            return x.description
        case .null:
            return "()"
        case .list(let car, let cdr):
            return "(" + car.description + " " + cdr.description + ")"
        }
    }
    
    var car: List<T>? {
        switch self {
        case .list(let acar, _):
            return acar
        default:
            return nil
        }
    }
    
    var cdr: List<T>? {
        switch self {
        case .list(_,let acdr):
            return acdr
        default:
            return nil
        }
    }
    
    var isNull: Bool {
        switch self {
        case .null:
            return true
        default:
            return false
        }
    }
    
    var isValue: Bool {
        switch self {
        case .value(_):
            return true
        default:
            return false
        }
    }
    
    var value: T {
        switch self {
        case .value(let x):
            return x
        default:
            fatalError("\(self) is not a value")
        }
    }
    
}

let x1 = List(1, 2)
let x2 = List(x1, x1)
let x3 = List(x2, 2)

