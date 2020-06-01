// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/05/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#if !os(watchOS)
import XCTest
import Coercion

@testable import DataFetcher

extension JSONDictionary: DescriptionEquatable { }

final class JSONTests: TestCase {

    func testJSON() {
        let a = ExampleStruct(value: 123)
        let expected: JSONDictionary = ["value": 123]
        check(send: a, for: 200, expecting: .success(expected), method: { fetcher, url, callback in
            fetcher.json(for: url, callback: callback)
        })
    }

    func testError() {
        let expected: Result<JSONDictionary, Error> = .failure(ExampleError())
        check(send: ExampleError(), for: 404, expecting: expected, method: { fetcher, url, callback in
            fetcher.json(for: url, callback: callback)
        })
    }
}
#endif
