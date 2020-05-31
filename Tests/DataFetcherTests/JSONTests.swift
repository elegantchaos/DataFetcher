import XCTest
import Coercion

@testable import DataFetcher

final class JSONTests: XCTestCase {
    struct A: Codable, DataConvertible {
        let name: String
    }

    func testJSON() {
        let a = A(name: "test")
        let x = expectation(description: "Decoded")
        let url = URL(string: "https://test.com/test")!
        let fetcher = MockDataFetcher(output: [
            url : .init(for: 200, return: a)
        ])
        
        let task = fetcher.json(for: url) { result, request in
            x.fulfill()
            switch result {
            case .success(let json):
                XCTAssertEqual(json[stringWithKey: "name"], "test")
                
            case .failure(let error): XCTFail("Unexpected error \(error).")
            }
        }
        
        task.resume()
        wait(for: [x], timeout: 1.0)
    }
}
