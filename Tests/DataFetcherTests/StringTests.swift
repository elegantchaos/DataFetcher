// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/05/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#if !os(watchOS)
import XCTest
import Coercion

@testable import DataFetcher

final class StringTests: TestCase {
    func testString() {
        check(send: .init("test", withStatus: 200), expecting: .success("test"), method: { fetcher, url, callback in
            fetcher.string(for: url, callback: callback)
        })
    }
    
    func testError() {
        check(send: .init(ExampleError(), withStatus: 404), expecting: .failure(ExampleError()), method: { fetcher, url, callback in
            fetcher.string(for: url, callback: callback)
        })
    }
  
}
#endif
