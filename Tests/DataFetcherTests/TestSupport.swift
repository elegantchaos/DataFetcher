// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/05/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import Coercion

@testable import DataFetcher

struct TestError: Error {
    var localizedDescription: String { "example error" }
}

func XCTAssertResultsMatch<T>(_ r1: Result<T, Error>, _ r2: Result<T, Error>, file: StaticString = #file, line: UInt = #line) where T: Equatable {
    if case let .success(d1) = r1, case let .success(d2) = r2 {
        XCTAssertEqual(d1, d2, file: file, line: line)
    } else if case let .failure(e1) = r1, case let .failure(e2) = r2 {
        XCTAssertEqual(e1.localizedDescription, e2.localizedDescription, file: file, line: line)
    } else {
        XCTFail("\(r1) != \(r2)", file: file, line: line)
    }
}

class TestCase: XCTestCase {
    
    func check<T>(send payload: Any, for code: Int, expecting: Result<T, Error>, method: @escaping (DataFetcher, URL, @escaping (Result<T, Error>, URLResponse?) -> Void) -> DataTask, file: StaticString = #file, line: UInt = #line) where T: Equatable {
        var returned: Result<T, Error>?
        let x = expectation(description: "Decoded")
        let url = URL(string: "https://test.com/test")!
        let fetcher = MockDataFetcher(output: [
            url : .init(for: code, return: payload)
        ])
        
        let task = method(fetcher, url, { result, request in
            returned = result
            x.fulfill()
        })
        
        
        task.resume()
        wait(for: [x], timeout: 1.0)
        
        XCTAssertNotNil(returned)
        XCTAssertResultsMatch(returned!, expecting, file: file, line: line)
    }
}
