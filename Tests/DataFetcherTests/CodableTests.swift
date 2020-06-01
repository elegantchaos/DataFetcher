// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/05/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#if !os(watchOS)

import XCTest
import Coercion

@testable import DataFetcher

final class CodableTests: TestCase {
    func testCodable() {
        let a = ExampleStruct(value: 123)
        check(send: .init(a, withStatus: 200), expecting: .success(a), method: { fetcher, url, callback in
            fetcher.codable(for: url, callback: callback)
        })
    }

    func testError() {
        let expected: Result<ExampleStruct, Error> = .failure(ExampleError())
        check(send: .init(ExampleError(), withStatus: 404), expecting: expected, method: { fetcher, url, callback in
            fetcher.codable(for: url, callback: callback)
        })
    }

}
#endif
