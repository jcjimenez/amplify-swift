//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify
import Foundation

/// Provides options specific to the AWS S3 plugin implementation of the Storage category.
///
/// Usage example:
///
/// ```
/// // Because `singleUploadSizeLimit` is set to `.gb(1)`, the
/// // underlying plugin will attempt to upload the given `Data`
/// // in a single `PutObject` request if its size is below 1GB.
/// let task = try await Amplify.Storage.uploadFile(
///     key: "ExampleKey",
///     data: localfileData,
///     options: .init(
///         pluginOptions: AWSStorageUploadDataOptions(
///             singleUploadSizeLimit: .gb(1)
///         )
///     )
/// )
/// ```
///
/// See:
/// * [StorageUploadDataRequestOptions.pluginOptions](x-source-tag://StorageUploadDataRequestOptions.pluginOptions)
/// * [StorageCategoryBehavior.uploadData](x-source-tag://StorageCategoryBehavior.uploadData)
///
///
/// - Tag: AWSStorageUploadDataOptions
public struct AWSStorageUploadDataOptions {

    /// When `singleUploadSizeLimit` is set and the size of the file being uploaded is **below**
    /// this value, the upload happens in one part. If the size of the file is greater than the given
    /// `singleUploadSizeLimit` value, then the upload is done using
    /// [multipart operations](https://docs.aws.amazon.com/AmazonS3/latest/userguide/mpuoverview.html).
    ///
    ///  Keep in mind that because the underlying representation of this size is expressed as a UIn64 and it
    ///  can represent a byte count up to 2^64 bytes. In addition, the size limits for AWS S3 can be found
    ///  [here](https://docs.aws.amazon.com/AmazonS3/latest/userguide/upload-objects.html).
    ///
    /// - Tag: AWSStorageUploadDataOptions.singleUploadSizeLimit
    public var singleUploadSizeLimit: FileSize

    /// - Tag: AWSStorageUploadFileOptions.defaultSingleUploadSizeLimit
    internal static let defaultSingleUploadSizeLimit: FileSize = .mb(5)

    /// - Tag: AWSStorageUploadDataOptions.init
    public init(singleUploadSizeLimit: FileSize = .mb(5)) {
        self.singleUploadSizeLimit = singleUploadSizeLimit
    }
}
