import XCTest
import Coercion

@testable import DataFetcher

final class CodableTests: TestCase {
    func testCodable() {
        let a = TestStruct(value: 123)
        check(send: a, for: 200, expecting: .success(a), method: { fetcher, url, callback in
            fetcher.codable(for: url, callback: callback)
        })
    }

    func testError() {
        let expected: Result<TestStruct, Error> = .failure(TestError())
        check(send: TestError(), for: 404, expecting: expected, method: { fetcher, url, callback in
            fetcher.codable(for: url, callback: callback)
        })
    }

}
