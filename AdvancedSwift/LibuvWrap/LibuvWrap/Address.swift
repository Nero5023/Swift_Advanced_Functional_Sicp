//
//  Address.swift
//  LibuvWrap
//
//  Created by Nero Zuo on 16/8/3.
//  Copyright © 2016年 Nero. All rights reserved.
//

import Foundation
import Libuv

class Address {
    var addr = UnsafeMutablePointer<sockaddr_in>.alloc(1)
    
    var address: UnsafePointer<sockaddr> {
        return UnsafePointer(addr)
    }
    
    init(host: String, port: Int) {
        uv_ip4_addr(host, Int32(port), addr)
    }
    
    deinit {
        addr.dealloc(1)
    }
}