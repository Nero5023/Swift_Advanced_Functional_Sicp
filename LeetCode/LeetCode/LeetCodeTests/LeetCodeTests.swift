//
//  LeetCodeTests.swift
//  LeetCodeTests
//
//  Created by Nero Zuo on 16/8/16.
//  Copyright © 2016年 Nero. All rights reserved.
//

import XCTest
@testable import LeetCode

class LeetCodeTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    let result = TwoSumSolution().twoSum2([2, 7, 11, 15], 9)
    XCTAssert(result == [0, 1] || result == [1, 0])
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measureBlock {
      // Put the code you want to measure the time of here.
      let result = TwoSumSolution().twoSum([2, 7, 11, 15, 45, 61, 45, 13, 53, 13, 55, 61, 90, 100, 23, 34, 56], 190)
    }
  }
  
}
