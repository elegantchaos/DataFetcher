import XCTest
import Coercion

@testable import DataFetcher

typealias DataResult = Result<Data, Error>
//
//extension Error {
//    func matches<T>(_ e2: T) -> Bool where T: Error {
//        guard let c1 = self as? Comparable, let c2 = e2 as? Comparable else { return false }
//        return c1 == c2
//    }
//}

struct TestError: Error {
    var localizedDescription: String { "example error" }
}
//
//extension TestError {
//    func matches<TestError>(_ e2: TestError) -> Bool {
//        return true
//    }
//}
func match(_ e1: Error, _ e2: Error) -> Bool {
    guard type(of: e1) == type(of: e2) else { return false }
    return true
}
func match(r1: DataResult, r2: DataResult) -> Bool {
    if case let .success(d1) = r1, case let .success(d2) = r2, d1 == d2 {
        return true
    }
    
    if case let .failure(e1) = r1, case let .failure(e2) = r2, e1.localizedDescription == e2.localizedDescription {
        return true
    }
    
    return false
}

final class DataTests: XCTestCase {
    
    func check(send payload: Any, for code: Int, expecting: DataResult) -> Bool {
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
        guard let result = returned, match(r1: result, r2: expecting) else {
            XCTFail("Unexpected response \(result).")
            return false
        }
        
        return true
    }
    
    func testData() {
        XCTAssertTrue(check(send: "test", for: 200, expecting: .success("test".data(using: .utf8)!)))
    }
    
    func testError() {
        XCTAssertTrue(check(send: TestError(), for: 404, expecting: .failure(TestError())))
    }
}
