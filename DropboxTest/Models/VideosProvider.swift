//
//  VideosProvider.swift
//  DropboxTest
//
//  Created by Alexander Sokolenko on 31.08.2023.
//

import UIKit
import SwiftyDropbox

final class VideosProvider: FilesMetadataProvider {
    
    private let errorDomain = "VideosProvider"
    
    func streamingLink(for path : String) async throws -> URL {
        guard let client = DropboxClientsManager.authorizedClient else {
            throw NSError(domain: errorDomain, code: 2)
        }
        let link : (Files.Metadata, String) = try await withCheckedThrowingContinuation {
            continuation in
            client.files.getTemporaryLink(path: path).response(completionHandler: {
                result, error in
                guard let result else {
                    continuation.resume(throwing: NSError(domain: self.errorDomain, code: 1, userInfo: [NSLocalizedDescriptionKey : error?.description ?? NSLocalizedString("Unknown error", comment: "")]))
                    return
                }
                continuation.resume(returning: (result.metadata, result.link))
            })
        }
        updateMetadata(link.0, for: path)
        guard let retVal = URL(string: link.1) else {
            throw NSError(domain: errorDomain, code: 3)
        }
        return retVal
    }
}
