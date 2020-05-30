import XCTest
@testable import DataFetcher

final class JSONSessionTests: XCTestCase {
    struct A: Codable, DataConvertible {
        let name: String
    }

    func testString() {
        let x = expectation(description: "Decoded")
        let url = URL(string: "https://test.com/test")!
        let fetcher = MockDataFetcher(output: [
            url : .init(for: 200, return: "test")
        ])
        
        let task = fetcher.data(for: url) { result, request in
            x.fulfill()
            switch result {
            case .success(let data): XCTAssertEqual(String(data: data, encoding: .utf8), "test")
            case .failure(let error): XCTFail("Unexpected error \(error).")
            }
        }
        
        task.resume()
        wait(for: [x], timeout: 1.0)
    }

    func testCodable() {
        let a = A(name: "test")
        let x = expectation(description: "Decoded")
        let url = URL(string: "https://test.com/test")!
        let fetcher = MockDataFetcher(output: [
            url : .init(for: 200, return: a)
        ])
        
        let task = fetcher.data(for: url) { result, request in
            x.fulfill()
            switch result {
            case .success(let data): XCTAssertEqual(String(data: data, encoding: .utf8), "test")
            case .failure(let error): XCTFail("Unexpected error \(error).")
            }
        }
        
        task.resume()
        wait(for: [x], timeout: 1.0)
    }
}
