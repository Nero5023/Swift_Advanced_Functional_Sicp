//
//  main.swift
//  sicptest
//
//  Created by Nero Zuo on 16/8/24.
//  Copyright © 2016年 Nero. All rights reserved.
//

import Foundation



func sumIteration(a a: Double, b: Double, term: (Double)->(Double), next: (Double)->(Double)) -> Double {
  func iter(a: Double, result: Double) -> Double {
    if a > b {
      return result
    }else {
      return iter(next(a), result: term(a)+result)
    }
  }
  return iter(a, result: 0)
}

print(sumIteration(a: 1, b: 10, term: { $0 }, next: { $0+1 }))