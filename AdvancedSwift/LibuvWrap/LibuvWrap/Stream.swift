//
//  Stream.swift
//  LibuvWrap
//
//  Created by Nero Zuo on 16/8/3.
//  Copyright © 2016年 Nero. All rights reserved.
//

import Foundation
import Libuv

enum UVError: ErrorType {
    case Error(code: Int32)
}

enum ReadResult {
    case Chunk(NSData)
    case EOF
    case Error(UVError)
    
    init(bytesRead: Int, buffer: UnsafePointer<uv_buf_t>) {
        if bytesRead == Int(UV_EOF.rawValue) {
            self = .EOF
        } else if bytesRead < 0 {
            self = .Error(.Error(code: Int32(bytesRead)))
        } else {
            self = .Chunk(NSData(bytes: buffer.memory.base, length: bytesRead))
        }
    }
}

typealias StreamRef = UnsafeMutablePointer<uv_stream_t>

typealias ReadBlock = ReadResult -> ()
typealias ListenBlock = (status: Int) -> ()
class StreamContext {
    var readBlock: ReadBlock?
    var listenBlock: ListenBlock?
}

class Stream {
    var stream: StreamRef
    
    init(_ stream: StreamRef) {
        self.stream = stream
    }
    
    func listen(backlog numConnections: Int, callback: uv_connection_cb) throws -> () {
        let result = uv_listen(stream, Int32(numConnections), callback)
        if result < 0 { throw UVError.Error(code: result) }
    }
    
    func closeAndFree() {
        uv_close(UnsafeMutablePointer(stream)) { handle in
            free(handle)
        }
    }
}


extension Stream {
    
    var context: StreamContext {
        if _context == nil {
            _context = StreamContext()
        }
        return _context!
    }
    
    var _context: StreamContext? {
        get {
            return unsafeFromVoidPointer(stream.memory.data)
        }
        set {
            let _: StreamContext? = releaseVoidPointer(stream.memory.data)
            stream.memory.data = retainedVoidPointer(newValue)
        }
    }
    
    func listen(numConnections: Int, theCallback: ListenBlock) throws -> () {
        context.listenBlock = theCallback
        try listen(backlog: numConnections) { (serverStream, status) in
            let stream = Stream(serverStream)
            stream.context.listenBlock?(status: Int(status))
        }
    }
    
    func read(callback: ReadBlock) throws {
        context.readBlock = callback
        uv_read_start(stream, alloc_buffer) { (serverStream, bytesRead, buf) in
            defer { free_buffer(buf) }
            let stream = Stream(serverStream)
            let data = ReadResult(bytesRead: bytesRead, buffer: buf)
            stream.context.readBlock?(data)
        }
    }
    
    
    func bufferedRead(callback: NSData -> ()) throws -> () {
        let mutableData = NSMutableData()
        try read { [unowned self] result in
            switch result {
            case .Chunk(let data):
                mutableData.appendData(data)
            case .EOF:
                callback(mutableData)
            case .Error(_):
                self.closeAndFree()
            }
        }
    }
    
    func accept(client: Stream) throws -> () {
        let result = uv_accept(stream, client.stream)
        if result < 0 { throw UVError.Error(code: result) }
    }
    
    func write(completion: () -> ()) -> BufferRef -> () {
        return { buffer in
            Write().writeAndFree(self, buffer: buffer, completion: completion)
        }
    }
    
    func writeData(data: NSData, completion: () -> ()) {
        data.withBufferRef(write(completion))
    }
    
    func put(data: NSData) {
        writeData(data) {
            self.closeAndFree()
        }
    }
}


private func alloc_buffer(_: UnsafeMutablePointer<uv_handle_t>, suggestedSize: Int, buffer: UnsafeMutablePointer<uv_buf_t>) -> () {
    buffer.memory = uv_buf_init(UnsafeMutablePointer.alloc(suggestedSize), UInt32(suggestedSize))
}

private func free_buffer(buffer: UnsafePointer<uv_buf_t>) {
    free(buffer.memory.base)
}
