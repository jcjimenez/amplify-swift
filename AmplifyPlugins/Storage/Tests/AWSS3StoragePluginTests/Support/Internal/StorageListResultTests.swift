//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
import AWSS3
import Amplify

@testable import AWSS3StoragePlugin

class StorageListResultTests: XCTestCase {

    func testObjectNonEmptyValidPrefix() throws {
        let prefix = "public/" + UUID().uuidString + "/"
        let fileName = "\(UUID().uuidString).txt"
        let key = prefix + fileName
        let object = S3ClientTypes.Object(eTag: UUID().uuidString,
                                          key: key,
                                          lastModified: Date(),
                                          size: Int.random(in: 512..<1024)
        )
        let item = try StorageListResult.Item(s3Object: object, prefix: prefix)
        XCTAssertEqual(item.key, fileName)
        XCTAssertEqual(item.eTag, object.eTag)
        XCTAssertEqual(item.lastModified, object.lastModified)
        XCTAssertEqual(item.size, object.size)
    }

    func testObjectNonEmptyInvalidPrefix() throws {
        // TODO: Confirm this behavior is acceptable, this test illustrates what is currently implemented but could cause bad (empty) object keys.
        let prefix = "public/" + UUID().uuidString + "/"
        let key = "\(UUID().uuidString).txt"
        let object = S3ClientTypes.Object(eTag: UUID().uuidString,
                                          key: key,
                                          lastModified: Date(),
                                          size: Int.random(in: 512..<1024)
        )
        let item = try StorageListResult.Item(s3Object: object, prefix: prefix)
        XCTAssertEqual(item.key, "")
        XCTAssertEqual(item.eTag, object.eTag)
        XCTAssertEqual(item.lastModified, object.lastModified)
        XCTAssertEqual(item.size, object.size)
    }

    func testObjectEmptyPrefix() throws {
        let object = S3ClientTypes.Object(eTag: UUID().uuidString,
                                          key: UUID().uuidString,
                                          lastModified: Date(),
                                          size: Int.random(in: 512..<1024)
        )
        let item = try StorageListResult.Item(s3Object: object, prefix: "")
        XCTAssertEqual(item.key, object.key)
        XCTAssertEqual(item.eTag, object.eTag)
        XCTAssertEqual(item.lastModified, object.lastModified)
        XCTAssertEqual(item.size, object.size)
    }

    func testObjectMissingKey() throws {
        let object = S3ClientTypes.Object()
        do {
            let _ = try StorageListResult.Item(s3Object: object, prefix: "")
            XCTFail("Expecting exception")
        } catch {
            let description = String(describing: error)
            XCTAssertTrue(description.contains("Missing key in response"), description)
        }
    }

    func testObjectMissingETag() throws {
        let object = S3ClientTypes.Object(key: UUID().uuidString)
        do {
            let _ = try StorageListResult.Item(s3Object: object, prefix: "")
            XCTFail("Expecting exception")
        } catch {
            let description = String(describing: error)
            XCTAssertTrue(description.contains("Missing eTag in response"), description)
        }
    }

    func testObjectMissingLastModified() throws {
        let object = S3ClientTypes.Object(eTag: UUID().uuidString, key: UUID().uuidString)
        do {
            let _ = try StorageListResult.Item(s3Object: object, prefix: "")
            XCTFail("Expecting exception")
        } catch {
            let description = String(describing: error)
            XCTAssertTrue(description.contains("Missing lastModified in response"), description)
        }
    }
}
