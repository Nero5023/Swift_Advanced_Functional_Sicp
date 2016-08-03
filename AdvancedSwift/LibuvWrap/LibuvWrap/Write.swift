//
//  Write.swift
//  LibuvWrap
//
//  Created by Nero Zuo on 16/8/3.
//  Copyright © 2016年 Nero. All rights reserved.
//

import Foundation
import Libuv

typealias BufferRef = UnsafePointer<uv_buf_t>
typealias WriteRef = UnsafeMutablePointer<uv_write_t>



class Write {
    var writeRef: WriteRef = WriteRef.alloc(1) // dealloced in the write callback
    
    func writeAndFree(stream: Stream, buffer: BufferRef, completion: () -> ()) {
        assert(writeRef != nil)
        
        writeRef.memory.data = retainedVoidPointer(completion)
        uv_write(writeRef, stream.stream, buffer, 1) { x, _ in
            let completionHandler: () -> () = releaseVoidPointer(x.memory.data)!
            free(x.memory.bufs)
            free(x)
            completionHandler()
        }
    }
}

extension NSData {
    func withBufferRef(callback: BufferRef -> ()) -> () {
        let bytes = UnsafeMutablePointer<Int8>.alloc(length)
        getBytes(bytes, length: length)
        var data = uv_buf_init(bytes, UInt32(length))
        withUnsafePointer(&data, callback)
    }
}