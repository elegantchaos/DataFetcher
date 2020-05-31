import XCTest
import Coercion

@testable import DataFetcher

extension JSONDictionary: DescriptionEquatable { }

final class JSONTests: TestCase {

    func testJSON() {
        let a = TestStruct(value: 123)
        let expected: JSONDictionary = ["value": 123]
        check(send: a, for: 200, expecting: .success(expected), method: { fetcher, url, callback in
            fetcher.json(for: url, callback: callback)
        })
    }

    func testError() {
        let expected: Result<JSONDictionary, Error> = .failure(TestError())
        check(send: TestError(), for: 404, expecting: expected, method: { fetcher, url, callback in
            fetcher.json(for: url, callback: callback)
        })
    }
}
