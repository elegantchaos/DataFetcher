#if !canImport(ObjectiveC)
import XCTest

extension CodableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__CodableTests = [
        ("testCodable", testCodable),
        ("testError", testError),
    ]
}

extension DataTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__DataTests = [
        ("testData", testData),
        ("testError", testError),
    ]
}

extension JSONTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__JSONTests = [
        ("testError", testError),
        ("testJSON", testJSON),
    ]
}

extension StringTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__StringTests = [
        ("testError", testError),
        ("testString", testString),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CodableTests.__allTests__CodableTests),
        testCase(DataTests.__allTests__DataTests),
        testCase(JSONTests.__allTests__JSONTests),
        testCase(StringTests.__allTests__StringTests),
    ]
}
#endif
