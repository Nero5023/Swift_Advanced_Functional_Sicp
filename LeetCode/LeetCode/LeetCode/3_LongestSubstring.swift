  //
//  3_LongestSubstring.swift
//  LeetCode
//
//  Created by Nero Zuo on 16/8/18.
//  Copyright © 2016年 Nero. All rights reserved.
//

import Foundation
class LengthOfLongestSubstringSolution {
  var count = 0
  var max = 0
  var lastChar: Character?
  var map: [Character: Int] = [:]
  func lengthOfLongestSubstring(s: String) -> Int {
    for char in s.characters {
      if let _ = map[char] {
        checkIsMax()
        checkLastCharIsSameWithNow(char)
      }else {
        count+=1
        map[char] = 0
      }
      lastChar = char
    }
    checkIsMax()
    return max
  }
  
  func checkIsMax() {
    if count > max {
      max = count
    }
  }
  
  func checkLastCharIsSameWithNow(char: Character) {
    if let lastChar = lastChar {
      if lastChar == char {
        count = 1
        map = [:]
        map[lastChar] = 0
      }
    }
  }
  
//  func reset(repeatChar: Character) {
//    count = 1
//    map = [:]
//    map[repeatChar] = 0
//  }
  
  func leng(s: String) -> Int {
    var max = 0
    var starIndex = -1
    for (index, char) in s.characters.enumerate() {
      if let repeatIndex = map[char] where repeatIndex > starIndex {
        starIndex = repeatIndex
      }
      if (index - starIndex) > max {
        max = index - starIndex
      }
      map[char] = index
    }
    return max
  }
}