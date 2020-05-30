// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/05/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
import Foundation

// TODO: move to separate package

/**
 Simple abstraction for fetching data synchronously from a URL and returning it as
 dictionary data.
 
 This mainly exists to allow us to use dependency injection to swap in a non network-dependent
 fetcher for testing purposes.
 */

public typealias DataCallback = (Result<Data, Error>, URLResponse?) -> Void
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
    func json(for request: URLRequest, callback: @escaping JSONCallback) -> DataTask
}

public extension DataFetcher {
    func data(for url: URL, callback: @escaping DataCallback) -> DataTask {
        return data(for: URLRequest(url: url), callback: callback)
    }
    
    func json(for url: URL, callback: @escaping JSONCallback) -> DataTask {
        return json(for: URLRequest(url: url), callback: callback)
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

