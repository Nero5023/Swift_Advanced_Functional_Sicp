//: Playground - noun: a place where people can play

import UIKit

//: # Inernal Structure of String

let hello = "helloworld111"
let bits = unsafeBitCast(hello, _StringCore.self)
print(bits)

struct StringCoreClone {
  var _baseAddress: COpaquePointer
  var _countAndFlags: UInt
  var _owner: AnyObject?
}

let cloneBits = unsafeBitCast(hello, StringCoreClone.self)

print(cloneBits._baseAddress)
cloneBits._countAndFlags
let output = puts(UnsafePointer(cloneBits._baseAddress))
print("output:\(output)")

let emoji = "Hello, 🌏"
let emojiBits = unsafeBitCast(emoji, StringCoreClone.self)
emojiBits._countAndFlags
print(emojiBits._baseAddress)
emoji._core.count
emoji.characters.count
