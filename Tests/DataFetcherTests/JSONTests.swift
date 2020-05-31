import XCTest
import Coercion

@testable import DataFetcher

extension JSONDictionary: DescriptionEquatable { }

final class JSONTests: TestCase {
    struct A: Codable, DataConvertible {
        let name: String
    }

//    func testJSON() {
//        let a = A(name: "test")
//        let x = expectation(description: "Decoded")
//        let url = URL(string: "https://test.com/test")!
//        let fetcher = MockDataFetcher(output: [
//            url : .init(for: 200, return: a)
//        ])
//
//        let task = fetcher.json(for: url) { result, request in
//            x.fulfill()
//            switch result {
//            case .success(let json):
//                XCTAssertEqual(json[stringWithKey: "name"], "test")
//
//            case .failure(let error): XCTFail("Unexpected error \(error).")
//            }
//        }
//
//        task.resume()
//        wait(for: [x], timeout: 1.0)
//    }
//
   
    
    func testJSON() {
        let a = A(name: "test")
        let expected: JSONDictionary = ["name": "test"]
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
