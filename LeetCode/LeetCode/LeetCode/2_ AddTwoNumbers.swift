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
  public init(_ val: Int, _ next: ListNode?) {
    self.val = val
    self.next = next
  }
}

extension ListNode: CustomStringConvertible {
  public var description: String {
    var node: ListNode? = self
    var result = ""
    while node != nil {
      result += String(node!.val)
      node = node?.next
    }
    return result
  }
}

class AddTwoNumbersSolution {
//  func addTwoNumbers(l1: ListNode?, _ l2: ListNode?) -> ListNode? {
//    guard let l1 = l1, l2 = l2 else { return nil }
//    let head = ListNode((l1.val+l2.val)%10)
//    var node = head
//    var tag = (l1.val+l2.val)/10
//    var l1node: ListNode? = l1
//    var l2node: ListNode? = l2
//    while (l1node!=nil && l2node!=nil) {
//      node.next = ListNode((l1.val+l2.val+tag)%10)
//      node = node.next!
//      tag = (l1.val+l2.val+tag)/10
//    }
//    return head
//  }
  
  func addTwoNumbers(l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    var l1node = l1
    var l2node = l2
    let head: ListNode = ListNode(0)
    var node = head
    var tag = 0
    while !(l1node==nil) || !(l2node==nil){
      node.next = ListNode(((l1node?.val ?? 0)+(l2node?.val ?? 0)+tag)%10)
      node = node.next!
      tag = ((l1node?.val ?? 0)+(l2node?.val ?? 0)+tag)/10
      l1node = l1node?.next
      l2node = l2node?.next
    }
    if tag == 1 {
      node.next = ListNode(1)
    }
    return head.next
  }
}