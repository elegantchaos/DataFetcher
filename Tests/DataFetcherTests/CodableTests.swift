import XCTest
import Coercion

@testable import DataFetcher

final class CodableTests: TestCase {
    struct A: Codable, DataConvertible, Equatable {
        let name: String
    }

    func testCodable() {
        let a = A(name: "test")
        check(send: "test", for: 200, expecting: .success(a), method: { fetcher, url, callback in
            fetcher.codable(for: url, callback: callback)
        })
    }

    func testError() {
        let expected: Result<A, Error> = .failure(TestError())
        check(send: TestError(), for: 404, expecting: expected, method: { fetcher, url, callback in
            fetcher.codable(for: url, callback: callback)
        })
    }

}
