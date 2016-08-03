//
//  Loop.swift
//  LibuvWrap
//
//  Created by Nero Zuo on 16/8/3.
//  Copyright © 2016年 Nero. All rights reserved.
//

import Foundation
import Libuv

typealias LoopRef = UnsafeMutablePointer<uv_loop_t>

class Loop {
    let loop: LoopRef
    
    init(loop: LoopRef = LoopRef.alloc(1)) {
        self.loop = loop
        uv_loop_init(loop)
    }
    
    func run(mode: uv_run_mode) {
        uv_run(loop, mode)
    }
    
    deinit {
        uv_loop_close(loop)
        loop.dealloc(1)
    }
    
    static var defaultLoop = Loop(loop: uv_default_loop())
}