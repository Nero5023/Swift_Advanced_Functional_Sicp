//
//  main.swift
//  LibuvWrap
//
//  Created by Nero Zuo on 16/8/3.
//  Copyright © 2016年 Nero. All rights reserved.
//

import Foundation
import Libuv



/**
 lopp and quit
 - parameter input: heloo world
 - returns: None
 */


func loopAndQuit() {
    let loop = UnsafeMutablePointer<uv_loop_t>.alloc(1)
    defer{
        print("Now dealloc")
        loop.dealloc(1)
    }
    
    uv_loop_init(loop)
    defer {
        print("Now close loop")
        uv_loop_close(loop)
    }
    
    print("Now Qutting")
    
    uv_run(loop, UV_RUN_DEFAULT)
}
//loopAndQuit()




func main() {
    let loop = Loop()
    print("Now Quitting")
    loop.run(UV_RUN_DEFAULT)
}

//main()



do {
    try run()
} catch {
    print(error)
}