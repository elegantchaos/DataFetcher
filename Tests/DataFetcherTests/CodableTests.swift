import XCTest
import Coercion

@testable import DataFetcher

final class CodableTests: XCTestCase {
    struct A: Codable, DataConvertible {
        let name: String
    }

    func testCodable() {
        let a = A(name: "test")
        let x = expectation(description: "Decoded")
        let url = URL(string: "https://test.com/test")!
        let fetcher = MockDataFetcher(output: [
            url : .init(for: 200, return: a)
        ])
        
        let task = fetcher.codable(for: url) { (result: Result<A, Error>, request) in
            x.fulfill()
            switch result {
            case .success(let decoded): XCTAssertEqual(decoded.name, "test")
            case .failure(let error): XCTFail("Unexpected error \(error).")
            }
        }
        
        task.resume()
        wait(for: [x], timeout: 1.0)
    }
}
