//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//


import Foundation

/// Convenience type to express file sizes. Uses a UIn64 to store the size measured in bytes.
///
/// Usage:
/// ```
/// let size: FileSize = .mb(10) /* 10MB */
/// print(size.byteCount) /* prints 10485760 */
/// ```
///
///  Keep in mind that because the underlying representation of this size is expressed as a UIn64 and it
///  can represent a byte count up to 2^64 bytes. In addition, the size limits for AWS S3 can be found
///  [here](https://docs.aws.amazon.com/AmazonS3/latest/userguide/upload-objects.html).
///
/// - Tag: FileSize
public struct FileSize {

    /// The size expressed in bytes represented by the receiver.
    ///
    /// - Tag: FileSize.bytes
    public private(set) var byteCount: UInt64

    /// - Tag: FileSize.initWithBytes
    public init(bytes: UInt64) {
        self.byteCount = bytes
    }

    /// - Tag: FileSize.kiloBytes
    public static func kb(_ value: UInt64) -> FileSize {
        return FileSize(bytes: value * (1024))
    }

    /// - Tag: FileSize.megaBytes
    public static func mb(_ value: UInt64) -> FileSize {
        return FileSize(bytes: value * (1024 * 1024))
    }

    /// - Tag: FileSize.gigaBytes
    public static func gb(_ value: UInt64) -> FileSize {
        return FileSize(bytes: value * (1024 * 1024 * 1024))
    }

}
