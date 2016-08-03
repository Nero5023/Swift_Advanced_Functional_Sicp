//
//  Helper.swift
//  LibuvWrap
//
//  Created by Nero Zuo on 16/8/3.
//  Copyright © 2016年 Nero. All rights reserved.
//

import Foundation

final class Box<A> {
    let unbox: A
    init(_ value: A) { unbox = value }
}


func retainedVoidPointer<A>(x: A?) -> UnsafeMutablePointer<Void> {
    guard let value = x else { return nil }
    let unmanaged = Unmanaged.passRetained(Box(value))
    return UnsafeMutablePointer(unmanaged.toOpaque())
}


func releaseVoidPointer<A>(x: UnsafeMutablePointer<Void>) -> A? {
    guard x != nil else { return nil }
    return Unmanaged<Box<A>>.fromOpaque(COpaquePointer(x))
        .takeRetainedValue().unbox
}


// Returns the value inside the pointer without releasing
func unsafeFromVoidPointer<A>(x: UnsafeMutablePointer<Void>) -> A? {
    guard x != nil else { return nil }
    return Unmanaged<Box<A>>.fromOpaque(COpaquePointer(x))
        .takeUnretainedValue().unbox
}