import XCTest
import Coercion

@testable import DataFetcher

final class StringTests: TestCase {
    func testString() {
        check(send: "test", for: 200, expecting: .success("test"), method: { fetcher, url, callback in
            fetcher.string(for: url, callback: callback)
        })
    }
    
    func testError() {
        check(send: TestError(), for: 404, expecting: .failure(TestError()), method: { fetcher, url, callback in
            fetcher.string(for: url, callback: callback)
        })
    }
  
}
