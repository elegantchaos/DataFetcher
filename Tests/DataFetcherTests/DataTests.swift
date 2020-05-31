import XCTest
import Coercion

@testable import DataFetcher

final class DataTests: TestCase {
    func testData() {
        check(send: "test", for: 200, expecting: .success("test".data(using: .utf8)!))
    }
    
    func testError() {
        check(send: TestError(), for: 404, expecting: .failure(TestError()))
    }
}
