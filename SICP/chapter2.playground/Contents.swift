//: Playground - noun: a place where people can play

import UIKit

func makeRat(x x: Int, d: Int) -> (Int, Int) {
    return (x,d)
}

func numer(x: (Int, Int)) -> Int {
    return x.0
}

func denom(x: (Int, Int)) -> Int {
    return x.1
}

func gcd(x: Int, _ y: Int) -> Int {
    if x < y {
        gcd(y, x)
    }
    if y == 0 {
        return x
    }
    return gcd(y, x%y)
}

struct RationalNumber {
    let number: Int
    let denom: Int
    
    init(number: Int, denom: Int) {
        let gcdResult = gcd(number, denom)
        self.number = number/gcdResult
        self.denom = denom/gcdResult
    }

}

func + (lhs: RationalNumber, rhs: RationalNumber) -> RationalNumber {
    return RationalNumber(number: lhs.number*rhs.denom + lhs.denom*rhs.number, denom: lhs.denom*rhs.denom)
}


func - (lhs: RationalNumber, rhs: RationalNumber) -> RationalNumber {
    return RationalNumber(number: lhs.number*rhs.denom - lhs.denom*rhs.number, denom: lhs.denom*rhs.denom)
}

func * (lhs: RationalNumber, rhs: RationalNumber) -> RationalNumber {
    return RationalNumber(number: lhs.number*rhs.number, denom: lhs.denom*rhs.denom)
}

func / (lhs: RationalNumber, rhs: RationalNumber) -> RationalNumber {
    return RationalNumber(number: lhs.number*rhs.denom, denom: lhs.denom*rhs.number)
}

extension RationalNumber: Equatable {}

func == (lhs: RationalNumber, rhs: RationalNumber) -> Bool {
    return lhs.number*rhs.denom == lhs.denom*rhs.number
}

extension RationalNumber: CustomStringConvertible {
    var description: String {
        return "\(number)/\(denom)"
    }
}

let x = RationalNumber(number: 9, denom: 6)
print(x)

func cons(x x: Int, y: Int) -> ((Int, Int)->Int) -> Int {
    return { m in
        m(x,y)
    }
}

func car(z: ((Int, Int)->Int) -> Int) -> Int {
    return z({(x, y) in x })
}
car(cons(x: 10, y: 8))