//
//  4_MedianOfTwoSortedArrays.swift
//  LeetCode
//
//  Created by Nero Zuo on 16/8/19.
//  Copyright © 2016年 Nero. All rights reserved.
//

import Foundation

class MedianOfTwoSortedArraysSolution {
  func findMedianSortedArrays(nums1: [Int], _ nums2: [Int]) -> Double {
    let totalCount = nums1.count + nums2.count
    if totalCount % 2 != 0 {
      return Double(findKthNum(nums1, nums2, k: totalCount/2 + 1))
    }else {
      return Double((findKthNum(nums1, nums2, k: totalCount/2) + findKthNum(nums1, nums2, k: totalCount/2 + 1))) / 2.0
    }
  }
  
  func findKthNum(nums1: [Int], _ nums2: [Int], k: Int) -> Int {
    if nums1.count > nums2.count {
      return findKthNum(nums2, nums1, k: k)
    }
    if nums1.count == 0 {
      guard k <= nums2.count else { fatalError("K is out the bounce") }
      return nums2[k-1]
    }
    
    if k == 1 {
      return min(nums1[0], nums2[0])
    }
    
    let count1 = min(k/2, nums1.count)
    let count2 = k - count1
    if nums1[count1-1] > nums2[count2-1] {
      return findKthNum(nums1, Array(nums2.dropFirst(count2)), k: k-count2)
    }else if nums1[count1-1] < nums2[count2-1] {
      return findKthNum(Array(nums1.dropFirst(count1)), nums2, k: k-count1)
    }else {
      return nums2[count2-1]
    }
  }
}
