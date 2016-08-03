//
//  TCP.swift
//  LibuvWrap
//
//  Created by Nero Zuo on 16/8/3.
//  Copyright © 2016年 Nero. All rights reserved.
//

import Foundation
import Libuv

class TCP: Stream {
    let socket = UnsafeMutablePointer<uv_tcp_t>.alloc(1)
    
    init(loop: Loop = Loop.defaultLoop) {
        super.init(UnsafeMutablePointer(self.socket))
        uv_tcp_init(loop.loop, socket)
    }
    
    func bind(address: Address) {
        uv_tcp_bind(socket, address.address, 0)
    }
}
