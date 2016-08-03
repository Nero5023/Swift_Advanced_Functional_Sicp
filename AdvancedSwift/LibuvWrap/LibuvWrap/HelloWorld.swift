//
//  HelloWorld.swift
//  LibuvWrap
//
//  Created by Nero Zuo on 16/8/3.
//  Copyright © 2016年 Nero. All rights reserved.
//

import Foundation
import Libuv

//func TCPServer(handleRequest:(Stream, NSData, ()->()) -> ()) throws {
//    
//    let numConnections = 1
//    
//    let server = TCP()
//    let addr = Address(host: "0.0.0.0", port: 8888)
//    server.bind(addr)
//    try server.listen(backlog: numConnections, callback: { (stream, status) in
//        let client = TCP()
////        try! server.accept(client)
//        client.closeAndFree()
//    })
//    Loop.defaultLoop.run(UV_RUN_DEFAULT)
//}


//func TCPServer(handleRequest:(Stream, NSData, ()->()) -> ()) throws {
//
//    let numConnections = 1
//
//    let server = TCP()
//    let addr = Address(host: "0.0.0.0", port: 8888)
//    server.bind(addr)
//    try server.listen(backlog: numConnections, callback: { (stream, status) in
//        let server = Stream(stream)
//        let client = TCP()
////        try! server.accept(client)
//        client.closeAndFree()
//    })
//    Loop.defaultLoop.run(UV_RUN_DEFAULT)
//}