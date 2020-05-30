// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/05/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/**
 Simple abstraction for fetching data asynchronously from a URL.
 
 Supports fetching as raw data, but also automatic decoding of the
 returned data as a JSON dictionary or a codable type.

 For real-world use, the standard URLSession type is conformed to the protocol.
 A mock version is also implemented which does not require the network.
 
 Client packages can use dependency injection to supply either implementation (or another)
 at runtime, which greatly simplifies testing.
 */

public typealias DataCallback = (Result<Data, Error>, URLResponse?) -> Void
public typealias StringCallback = (Result<String, Error>, URLResponse?) -> Void
public typealias JSONCallback = (Result<JSONDictionary, Error>, URLResponse?) -> Void

public enum DataFetcherError: Error {
    case couldntDecodeJSON
    case noDataOrError
}

public protocol DataTask {
    var isDone: Bool { get }
    func resume()
    func cancel()
}

public protocol DataFetcher {
    func data(for request: URLRequest, callback: @escaping DataCallback) -> DataTask
    func string(for request: URLRequest, callback: @escaping StringCallback) -> DataTask
    func json(for request: URLRequest, callback: @escaping JSONCallback) -> DataTask
    func codable<T>(for request: URLRequest, callback: @escaping (Result<T, Error>, URLResponse?) -> Void) -> DataTask where T: Codable
}

public extension DataFetcher {
    func data(for url: URL, callback: @escaping DataCallback) -> DataTask {
        return data(for: URLRequest(url: url), callback: callback)
    }

    func string(for url: URL, callback: @escaping StringCallback) -> DataTask {
        return string(for: URLRequest(url: url), callback: callback)
    }

    func json(for url: URL, callback: @escaping JSONCallback) -> DataTask {
        return json(for: URLRequest(url: url), callback: callback)
    }

    func codable<T>(for url: URL, callback: @escaping (Result<T, Error>, URLResponse?) -> Void) -> DataTask where T: Codable {
        return codable(for: URLRequest(url: url), callback: callback)
    }

    func string(for request: URLRequest, callback: @escaping StringCallback) -> DataTask {
        data(for: request) { result, request in
            let translated: Result<String, Error>
            switch result {
            case .success(let data):
                if let string = String(data: data, encoding: .utf8) {
                    translated = .success(string)
                } else {
                    translated = .failure(DataFetcherError.couldntDecodeJSON)
                }
            case .failure(let error):
                translated = .failure(error)
            }
            callback(translated, request)
        }
    }

    func json(for request: URLRequest, callback: @escaping JSONCallback) -> DataTask {
        data(for: request) { result, request in
            let translated: Result<JSONDictionary, Error>
            switch result {
            case .success(let data):
                if let parsed = try? JSONSerialization.jsonObject(with: data, options: []), let json = parsed as? JSONDictionary {
                    translated = .success(json)
                } else {
                    translated = .failure(DataFetcherError.couldntDecodeJSON)
                }
            case .failure(let error):
                translated = .failure(error)
            }
            callback(translated, request)
        }
    }

    func codable<T>(for request: URLRequest, callback: @escaping (Result<T, Error>, URLResponse?) -> Void) -> DataTask where T: Codable {
        data(for: request) { result, request in
            let translated: Result<T, Error>
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode(T.self, from: data) {
                    translated = .success(decoded)
                } else {
                    translated = .failure(DataFetcherError.couldntDecodeJSON)
                }
            case .failure(let error):
                translated = .failure(error)
            }
            callback(translated, request)
        }
    }

}

extension URLSessionDataTask: DataTask {
    public var isDone: Bool {
        state == .completed
    }
}

extension URLSession: DataFetcher {
    public func data(for request: URLRequest, callback: @escaping DataCallback) -> DataTask {
        let task = dataTask(with: request) { data, response, error in
            if let error = error {
                callback(.failure(error), response)
            } else if let data = data {
                callback(.success(data), response)
            } else {
                callback(.failure(DataFetcherError.noDataOrError), response)
            }
        }
        return task
    }
}

