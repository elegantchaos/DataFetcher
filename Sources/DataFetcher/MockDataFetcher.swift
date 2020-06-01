// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 30/05/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import Coercion

/**
 Test fetcher which ignores the URL and just returns the data it's been given.
 Useful for testing.
 */

public struct MockDataFetcher: DataFetcher {
    public class Task: DataTask {
        let payload: Result<Data, Error>
        let response: URLResponse?
        let callback: DataCallback
        
        init(_ payload: Result<Data,Error>, response: URLResponse? = nil, callback: @escaping DataCallback) {
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
            callback(payload, response)
            isDone = true
        }
    }

    public struct Output {
        let code: Int
        let payload: Result<Data, Error>

        public init<T>(_ payload: T, withStatus code: Int) where T: Encodable, T: DataConvertible { /// DataConvertible takes precendence over Encodable
            self.code = code
            self.payload = .success(payload.asData!)
        }

        public init<T>(_ rawPayload: T, withStatus code: Int) where T: Encodable {
            let encoder = JSONEncoder()
            let encoded = try! encoder.encode(rawPayload)
            self.code = code
            self.payload = .success(encoded)
        }

        public init<T>(_ payload: T, withStatus code: Int) where T: DataConvertible {
            self.code = code
            self.payload = .success(payload.asData!)
        }

        init(_ error: Error, withStatus code: Int) {
            self.code = code
            self.payload = .failure(error)
        }
        
        init(_ data: Data, withStatus code: Int) {
            self.code = code
            self.payload = .success(data)
        }
    }

    public let output: [URL:Output]

    public init<T>(for url: URL, return payload: T, withStatus code: Int) where T: Encodable, T: DataConvertible {
        self.output = [url:Output(payload, withStatus: code)]
    }

    public init<T>(for url: URL, return payload: T, withStatus code: Int) where T: Encodable {
        self.output = [url:Output(payload, withStatus: code)]
    }

    public init<T>(for url: URL, return payload: T, withStatus code: Int) where T: DataConvertible {
        self.output = [url:Output(payload, withStatus: code)]
    }

    public init(for url: URL, return data: Data, withStatus code: Int) {
        self.output = [url:Output(data, withStatus: code)]
    }

    public init(for url: URL, return error: Error, withStatus code: Int) {
        self.output = [url:Output(error, withStatus: code)]
    }

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
