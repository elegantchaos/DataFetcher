// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/05/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#if !os(watchOS)
import XCTest
import Coercion

@testable import DataFetcher

final class DataTests: TestCase {
    func testData() {
        check(send: "test", for: 200, expecting: .success("test".data(using: .utf8)!), method: { fetcher, url, callback in
            fetcher.data(for: url, callback: callback)
        })
    }
    
    func testError() {
        check(send: ExampleError(), for: 404, expecting: .failure(ExampleError()), method: { fetcher, url, callback in
            fetcher.data(for: url, callback: callback)
        })
    }
}
#endif
