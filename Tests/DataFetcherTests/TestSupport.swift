// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/05/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import Coercion

@testable import DataFetcher

typealias DataResult = Result<Data, Error>

struct TestError: Error {
    var localizedDescription: String { "example error" }
}

func XCTAssertResultsMatch(_ r1: DataResult, _ r2: DataResult, file: StaticString = #file, line: UInt = #line) {
    if case let .success(d1) = r1, case let .success(d2) = r2 {
        XCTAssertEqual(d1, d2, file: file, line: line)
    } else if case let .failure(e1) = r1, case let .failure(e2) = r2 {
        XCTAssertEqual(e1.localizedDescription, e2.localizedDescription, file: file, line: line)
    } else {
        XCTFail("\(r1) != \(r2)", file: file, line: line)
    }
}

class TestCase: XCTestCase {
   
   func check(send payload: Any, for code: Int, expecting: DataResult, file: StaticString = #file, line: UInt = #line) {
       var returned: Result<Data, Error>?
       let x = expectation(description: "Decoded")
       let url = URL(string: "https://test.com/test")!
       let fetcher = MockDataFetcher(output: [
           url : .init(for: code, return: payload)
       ])
       
       let task = fetcher.data(for: url) { result, request in
           returned = result
           x.fulfill()
       }
       
       task.resume()
       wait(for: [x], timeout: 1.0)
       
       XCTAssertNotNil(returned)
       XCTAssertResultsMatch(returned!, expecting, file: file, line: line)
   }
}
