//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import AWSS3
import Amplify
import Foundation

/// Concrete implementation of the an
/// [AsyncIteratorProtocol](x-source-tag://AsyncIteratorProtocol) used as a larger
/// implementation of an S3 [ObjectListing](x-source-tag://ObjectListing).
///
/// - Tag: StorageItemPageIterator
struct StorageItemPageIterator {

    private var client: S3ClientProtocol

    private var input: ListObjectsV2Input

    private var response: ListObjectsV2OutputResponse
    
    private var nextContents: [S3ClientTypes.Object]?

    init(client: S3ClientProtocol, input: ListObjectsV2Input, response: ListObjectsV2OutputResponse) {
        self.client = client
        self.input = input
        self.response = response
        self.pushContents()
    }
    
    private mutating func pushContents() {
        self.nextContents = response.contents
    }
    
    private mutating func popContents() -> [S3ClientTypes.Object]? {
        guard let contents = nextContents else {
            return nil
        }
        nextContents = nil
        return contents
    }
}

extension StorageItemPageIterator: AsyncIteratorProtocol {
    mutating func next() async throws -> [StorageListResult.Item]? {
        if let contents = popContents() {
            let prefix = self.input.prefix
            return try contents.map { object in
                return try StorageListResult.Item(s3Object: object, prefix: prefix ?? "")
            }
        }
        guard let nextContinuationToken = response.nextContinuationToken else {
            return nil
        }
        var input = input
        input.continuationToken = nextContinuationToken
        self.response = try await client.listObjectsV2(input: input)
        self.input = input
        self.pushContents()
        return try await next()
    }
}
