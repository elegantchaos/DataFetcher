import XCTest
import Coercion

@testable import DataFetcher

final class StringTests: XCTestCase {
    struct A: Codable, DataConvertible {
        let name: String
    }

    func testString() {
        let x = expectation(description: "Decoded")
        let url = URL(string: "https://test.com/test")!
        let fetcher = MockDataFetcher(output: [
            url : .init(for: 200, return: "test")
        ])
        
        let task = fetcher.string(for: url) { result, request in
            x.fulfill()
            switch result {
            case .success(let string): XCTAssertEqual(string, "test")
            case .failure(let error): XCTFail("Unexpected error \(error).")
            }
        }
        
        task.resume()
        wait(for: [x], timeout: 1.0)
    }
}
