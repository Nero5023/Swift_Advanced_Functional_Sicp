//: Playground - noun: a place where people can play

import UIKit

infix operator >>> { associativity left }

func >>> <A, B, C>(f: A->B, g: B->C) -> A->C {
    return { x in
        g(f(x))
    }
}

func curry<A, B, C>(f: (A, B)->C) -> A->B->C {
    return { x in { y in f(x, y) } }
}

