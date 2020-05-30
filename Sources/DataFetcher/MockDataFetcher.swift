// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 30/05/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import Coercion

/**
 Test fetcher which ignores the URL and just returns the data it's been given.
 Useful for testing.
 */

public struct MockDataFetcher: DataFetcher {
    public class Task<Payload>: DataTask {
        let payload: Payload
        let response: URLResponse?
        let callback: DataCallback
        
        init(_ payload: Payload, response: URLResponse? = nil, callback: @escaping DataCallback) {
            self.payload = payload
            self.response = response
            self.callback = callback
        }
        
        public var isDone = false
        public func cancel() { }
        public func resume() {
            DispatchQueue.global(qos: .default).async(execute: execute)
        }
        
        func execute() {
            if let data = payload as? Data {
                callback(.success(data), response)
            } else if let convertible = payload as? DataConvertible, let data = convertible.asData {
                callback(.success(data), response)
            } else if let error = payload as? Error {
                callback(.failure(error), response)
            } else {
                fatalError("Invalid payload type \(payload).")
            }
            isDone = true
        }
    }

    public struct Output {
        let code: Int
        let payload: Any
        
        init(for code: Int, return payload: Any) {
            self.code = code
            self.payload = payload
        }
    }

    public let output: [URL:Output]
    
    public init(output: [URL:Output]) {
        self.output = output
    }
    
    public func data(for request: URLRequest, callback: @escaping DataCallback) -> DataTask {
        guard let url = request.url else { fatalError("Request had no URL.") }
        guard let output = output[url] else { fatalError("Request had no URL.") }

        let response = HTTPURLResponse(url: url, statusCode: output.code, httpVersion: "1.0", headerFields: [:])
        return Task(output.payload, response: response, callback: callback)
    }
}
