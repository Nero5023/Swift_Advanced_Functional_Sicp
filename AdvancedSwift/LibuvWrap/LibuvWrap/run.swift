//
//  run.swift
//  LibuvWrap
//
//  Created by Nero Zuo on 16/8/3.
//  Copyright © 2016年 Nero. All rights reserved.
//

import Foundation
import Libuv

typealias RequestHandler = (data: NSData, sink: NSData -> ()) -> ()

func runTCPServer(handleRequest: RequestHandler) throws {
    let numConnections = 10
    
    let server = TCP()
    let addr = Address(host: "0.0.0.0", port: 8888)
    server.bind(addr)
    try server.listen(numConnections){ (status) in
        guard status >= 0 else { return }
        let client = TCP()
        do {
            try server.accept(client)
            try client.bufferedRead { data in
                handleRequest(data: data, sink: client.put)
            }
        }catch {
            client.closeAndFree()
        }
    }
    Loop.defaultLoop.run(UV_RUN_DEFAULT)
}


func run() throws {
    try runTCPServer() { data, sink in
        if let string = String.fromCString(UnsafePointer(data.bytes)),
            let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            print(string)
            sink(data)
        }
    }
}
