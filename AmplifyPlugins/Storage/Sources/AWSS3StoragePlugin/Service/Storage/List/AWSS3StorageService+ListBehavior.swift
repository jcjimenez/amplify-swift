//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import AWSClientRuntime
import AWSS3
import Amplify
import ClientRuntime
import Foundation

extension AWSS3StorageService {

    func list(prefix: String,
              options: StorageListRequest.Options) async throws -> StorageListResult {
        let finalPrefix: String
        if let path = options.path {
            finalPrefix = prefix + path
        } else {
            finalPrefix = prefix
        }
        let input = ListObjectsV2Input(bucket: bucket,
                                       continuationToken: nil,
                                       delimiter: nil,
                                       maxKeys: 1_000,
                                       prefix: finalPrefix,
                                       startAfter: nil)
        var listing = try await StorageListing.create(with: self.client, input: input)
        let items = try await listing.firstPage()
        return StorageListResult(items: items)
    }
    
}
