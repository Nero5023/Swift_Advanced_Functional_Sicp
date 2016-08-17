//
//  2_ AddTwoNumbers.swift
//  LeetCode
//
//  Created by Nero Zuo on 16/8/16.
//  Copyright © 2016年 Nero. All rights reserved.
//

import Foundation

public class ListNode {
      public var val: Int
      public var next: ListNode?
      public init(_ val: Int) {
          self.val = val
          self.next = nil
     }
 }
 
class Solution {
  func addTwoNumbers(l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    guard let l1 = l1, l2 = l2 else { return nil }
    let head = ListNode((l1.val+l2.val)%10)
    var node = head
    var tag = (l1.val+l2.val)/10
    while let l1 = l1.next, l2 = l2.next {
      node.next = ListNode((l1.val+l2.val+tag)%10)
      node = node.next!
      tag = (l1.val+l2.val+tag)/10
    }
    return head
  }
}