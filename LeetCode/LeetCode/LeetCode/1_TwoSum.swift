//
//  1_TwoSum.swift
//  LeetCode
//
//  Created by Nero Zuo on 16/8/16.
//  Copyright © 2016年 Nero. All rights reserved.
//

import Foundation
class TwoSumSolution {
  func twoSum(nums: [Int], _ target: Int) -> [Int] {
    for (index, num) in nums.enumerate() {
      
      for index2 in index.successor()..<nums.endIndex {
        if num + nums[index2] == target {
          return [index, index2]
        }
      }
    }
    return []
  }
  
  func twoSum2(nums:[Int], _ target: Int) -> [Int] {
    var map = [Int: Int]()
    for (index, num) in nums.enumerate() {
      map[num] = index
    }
    for (index, num) in nums.enumerate() {
      if let anotherIndex = map[target-num] where index != anotherIndex {
        return [index, anotherIndex]
      }
    }
    return []
  }
}