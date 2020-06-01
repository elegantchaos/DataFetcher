// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/05/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#if !os(watchOS)
import XCTest
import Coercion
import XCTestExtensions

@testable import DataFetcher

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


struct ExampleError: Error {
    var localizedDescription: String { "example error" }
}

struct ExampleStruct: Codable, DataConvertible, Equatable {
    let value: Int
}

protocol DescriptionEquatable: CustomStringConvertible {
}

class TestCase: XCTestCase {
    
    func check<T>(send payload: Any, for code: Int, expecting: Result<T, Error>, method: @escaping (DataFetcher, URL, @escaping (Result<T, Error>, URLResponse?) -> Void) -> DataTask, file: StaticString = #file, line: UInt = #line) where T: Equatable {
        var returned: Result<T, Error>?
        let x = expectation(description: "Decoded")
        let url = URL(string: "https://test.com/test")!
        let fetcher = MockDataFetcher(for: url, return: payload, withStatus: code)
        
        let task = method(fetcher, url, { result, request in
            returned = result
            x.fulfill()
        })
        
        
        task.resume()
        wait(for: [x], timeout: 1.0)
        
        XCTAssertNotNil(returned)
        XCTAssertEqual(returned!, expecting, file: file, line: line)
    }

    // TODO: generalise this so we don't have to repeat code
    func check<T>(send payload: Any, for code: Int, expecting: Result<T, Error>, method: @escaping (DataFetcher, URL, @escaping (Result<T, Error>, URLResponse?) -> Void) -> DataTask, file: StaticString = #file, line: UInt = #line) where T: DescriptionEquatable {
        var returned: Result<T, Error>?
        let x = expectation(description: "Decoded")
        let url = URL(string: "https://test.com/test")!
        let fetcher = MockDataFetcher(for: url, return: payload, withStatus: code)

        let task = method(fetcher, url, { result, request in
            returned = result
            x.fulfill()
        })
        
        
        task.resume()
        wait(for: [x], timeout: 1.0)
        
        XCTAssertNotNil(returned)
        XCTAssertEqual(returned!, expecting, file: file, line: line)
    }

}
#endif
