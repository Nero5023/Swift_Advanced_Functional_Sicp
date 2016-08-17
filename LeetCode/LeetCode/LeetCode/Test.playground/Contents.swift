//: Playground - noun: a place where people can play

import UIKit

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

let nums = [1,2,3]
nums.dropFirst(1)