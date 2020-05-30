import XCTest
@testable import DataFetcher

final class JSONSessionTests: XCTestCase {
    struct A: Codable {
        let name: String
    }

    func testData() {
        let x = expectation(description: "Decoded")
        let url = URL(string: "https://test.com/test")!
        let fetcher = MockDataFetcher(output: [
            url : .init(for: 200, return: "test")
        ])
        
        let task = fetcher.data(for: url) { data, request, error in
            x.fulfill()
            XCTAssertNotNil(data)
            XCTAssertNil(error)
        }
        
        task.resume()
        wait(for: [x], timeout: 1.0)
    }

    func testExample() {
        let a = A(name: "test")
        let encoder = JSONEncoder()
        let json = try! encoder.encode(a)
        let x = expectation(description: "Decoded")
        let url = URL(string: "https://test.com/test")!
        let fetcher = MockDataFetcher(output: [
            url : .init(for: 200, return: json)
        ])
        
        let task = fetcher.data(for: url) { data, request, error in
            x.fulfill()
            XCTAssertNotNil(data)
            XCTAssertNil(error)
        }
        
        task.resume()
        wait(for: [x], timeout: 1.0)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
